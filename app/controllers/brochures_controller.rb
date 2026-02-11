class BrochuresController < ApplicationController
  layout 'default' # applies to all actions
  before_action :authenticate_user!

  def show
    @brochure = Brochure.find(params[:id])
    @editing = false
    respond_to do |format|
      format.html # { render layout: 'pdf' }
      format.pdf do
        html = render_to_string(
          template: 'brochures/show',
          layout: 'pdf',
          formats: [:html]
        )
        grover = Grover.new(
          html,
          display_url: request.base_url,
          # print_background: true,
          # wait_until: 'domcontentloaded',
          timeout: 60_000,
          launch_args: ['--no-sandbox', '--disable-setuid-sandbox',
    '--disable-dev-shm-usage'],

        )
        send_data grover.to_pdf,
          filename: 'gim.pdf',
          type: 'application/pdf',
          disposition: 'inline'
      end
    end
  end

  def create
    brochure = current_user.brochures.new(brochure_params)

    if brochure.save
      redirect_to users_profile_path, notice: 'Brochure created'
    else
      redirect_to users_profile_path, alert: brochure.errors.full_messages.to_sentence
    end
  end

  def edit_layout
    @brochure = Brochure
      .includes(pages: :blocks)
      .find(params[:id])
    @editing = true
  end

  def update_theme
    @brochure = Brochure.find(params[:id])
    # 1. Properly permit the nested structure
    # We allow colors to have primary, background, and text keys
    safe_overrides = params.require(:overrides).permit(
      colors: %i[primary background text],
      fonts: [:main]
    ).to_h

    # Ensure we are merging into a hash, even if theme_overrides is currently nil
    current_overrides = @brochure.theme_overrides || {}

    # Store overrides like { "colors" => { "primary" => "#ff0000" } }
    new_overrides = current_overrides.deep_merge(safe_overrides)

    if @brochure.update(theme_overrides: new_overrides)
      render json: { message: 'Style updated!' }, status: :ok
    else
      render json: { error: 'Failed to save' }, status: :unprocessable_entity
    end
  end

  def destroy
    brochure = current_user.brochures.find(params[:id])
    brochure.destroy
    redirect_to users_profile_path, notice: 'Brochure deleted'
  end

  private

  def set_brochure
    @brochure = Brochure
      .includes(pages: :blocks)
      .find(params[:id])
  end

  def brochure_params
    params.require(:brochure).permit(:title, :brochure_preset_id, :client_id)
  end
end
