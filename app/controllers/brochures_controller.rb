class BrochuresController < ApplicationController
  include Pundit::Authorization # Inclus Pundit

  layout 'default' # applies to all actions
  before_action :authenticate_user!
  before_action :set_brochure, only: %i[show edit_layout update_theme destroy]

  def show
    @brochure = Brochure.find(params[:id])
    authorize @brochure # Vérifie les permissions (show?)
    @editing = false
    respond_to do |format|
      format.html # { render layout: 'pdf' }
      format.pdf do
        html = render_to_string(
          template: 'brochures/show',
          layout: 'pdf',
          formats: [:html]
        ) # .to_str

        grover = Grover.new(
          html,
          display_url: request.base_url,
          # print_background: true,
          wait_until: 'domcontentloaded',
          timeout: 60_000,
          launch_args: ['--no-sandbox', '--disable-setuid-sandbox',
                        '--disable-gpu', '--disable-dev-shm-usage',
                        '--font-render-hinting=none', '--single-process']
        )
        send_data grover.to_pdf,
                  filename: 'gim.pdf',
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  def create
    @brochure = current_user.brochures.new(brochure_params)
    authorize @brochure # Vérifie les permissions (show?)
    if @brochure.save
      redirect_to users_profile_path, notice: 'Brochure created'
    else
      redirect_to users_profile_path, alert: brochure.errors.full_messages.to_sentence
    end
  end

  def edit_layout
    @brochure = Brochure
      .includes(pages: :blocks)
      .find(params[:id])
    authorize @brochure # Vérifie les permissions (show?)
    @editing = true
  end

  def update_theme
    @brochure = Brochure.find(params[:id])
    authorize @brochure # Vérifie les permissions (show?)
    # 1. Properly permit the nested structure
    # We allow colors to have primary, background, and text keys
    safe_overrides = params.fetch(:overrides, {}).permit(
      colors: %i[primary background text],
      fonts: [:main]
    ).to_h
    new_layout = params[:custom_cover_layout] || params.dig(:brochure, :custom_cover_layout)

    current_overrides = @brochure.theme_overrides || {}
    # Store overrides like { "colors" => { "primary" => "#ff0000" } }
    new_overrides = current_overrides.deep_merge(safe_overrides)

    # 4. Prepare update hash
    update_data = { theme_overrides: new_overrides }
    update_data[:custom_cover_layout] = new_layout if new_layout.present?

    if @brochure.update(update_data)
      render json: { message: 'Style updated!' }, status: :ok
    else
      render json: { error: 'Failed to save' }, status: :unprocessable_entity
    end
  end

  def destroy
    @brochure = current_user.brochures.find(params[:id])
    authorize @brochure # Vérifie les permissions (show?)
    @brochure.destroy
    redirect_to users_profile_path, notice: 'Brochure deleted'
  end

  private

  def set_brochure
    @brochure = Brochure
      .includes(pages: :blocks)
      .find(params[:id])
  end

  def brochure_params
    params.require(:brochure).permit(:title, :brochure_preset_id, :client_id, :custom_cover_layout)
  end
end
