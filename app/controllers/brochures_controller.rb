class BrochuresController < ApplicationController
  include Pundit::Authorization # Inclus Pundit
  require 'caxlsx'
  require "roo"

  layout 'default' # applies to all actions
  before_action :authenticate_user!, except: [:show, :export_guests, :import_guests ]
  before_action :set_brochure, only: %i[
    show edit_layout
    update_theme destroy
    export_guests import_guests
  ]

  def show
    authorize @brochure

    @editing = false

    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(
          template: 'brochures/show',
          layout: 'pdf',
          formats: [:html],
          locals: {
            pdf_export: true
          }
        )

        grover = Grover.new(
          html,
          display_url: request.base_url,
          wait_until: 'domcontentloaded',
          timeout: 60_000,
          launch_args: ['--no-sandbox', '--disable-setuid-sandbox',
                        '--disable-gpu', '--disable-dev-shm-usage',
                        '--font-render-hinting=none', '--single-process']
        )
        send_data grover.to_pdf,
                  filename: "#{@brochure.title.parameterize}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  def create
    @brochure = current_user.brochures.new(brochure_params)
    authorize @brochure
    if @brochure.save
      redirect_to users_profile_path, notice: 'Brochure creée'
    else
      redirect_to users_profile_path, alert: @brochure.errors.full_messages.to_sentence
    end
  end

  def edit_layout
    @brochure = Brochure
      .includes(pages: :blocks)
      .find(params[:id])
    authorize @brochure
    @editing = true
  end

  def update_theme
    authorize @brochure
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
      render json: { message: 'Style mis à jour' }, status: :ok
    else
      render json: { error: 'Echec de sauvegarde' }, status: :unprocessable_entity
    end
  end

  def toggle_watermark
    @brochure = Brochure.find(params[:id])
    @brochure.update!(
      watermark_enabled: params[:watermark_enabled]
    )
    head :ok
  end

  def export_guests
    authorize @brochure

    guests = @brochure.invitation_guests
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(
      name: "Invités"
    ) do |sheet|

      sheet.add_row [
        "Nom",
        "Téléphone",
        "Table",
        "Statut",
        "Présent",
        "Check-in"
      ]

      guests.each do |guest|
        sheet.add_row [
          guest.name,
          guest.phone,
          guest.table,
          guest.status,
          guest.accepted? ? "OUI" : "NON",
          guest.checked_in? ? 
            guest.checked_in_at.strftime("%d/%m/%Y %H:%M") :
            "Pas encore"
        ]
      end
    end

    send_data(
      package.to_stream.read,
      filename: "#{@brochure.title.parameterize}-invites.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      disposition: "attachment"
    )
  end

  def import_guests
    authorize @brochure

    file = params[:file]

    unless file.present?
      redirect_to album_gallery_path(@brochure.client.album),
        alert:"Choisissez un fichier"
      return
    end

    xlsx = Roo::Spreadsheet.open(
      file.path,
      extension: :xlsx
    )

    xlsx.each_row_streaming(
      offset: 1
    ) do |row|

      name  = row[0].value
      phone = row[1].value
      table = row[2].value

      next if name.blank?

      @brochure.invitation_guests.create!(
        name: name,
        phone: phone,
        table: table
      )
    end

    redirect_to album_gallery_path(@brochure.client.album),
      notice:"Invités importés"
  end

  def destroy
    @brochure = current_user.brochures.find(params[:id])
    authorize @brochure
    @brochure.destroy
    redirect_to users_profile_path, notice: 'Brochure suprimée'
  end

  private

  def set_brochure
    @brochure = Brochure
      .includes(pages: :blocks)
      .find(params[:id])
  end

  def brochure_params
    params.require(:brochure).permit(:title, :brochure_preset_id, :client_id, :custom_cover_layout, :kind)
  end
end
