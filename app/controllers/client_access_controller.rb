class ClientAccessController < ApplicationController
  layout 'default' # applies to all actions
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  def show
    @album = Album.friendly.find(params[:id])
  end

  def authenticate
    @album = Album.friendly.find(params[:id])
    if @album.authenticate(params[:password])
      # Set a session variable to grant temporary access
      session[:authenticated_album_id] = @album.id
      redirect_to album_gallery_path(@album)
    else
      flash.now[:alert] = ' Mot de passe incorrect.'
      render :show, status: :unauthorized
    end
  end

  # This action displays the actual gallery after successful authentication
  def gallery
    @album = Album.friendly.find(params[:id])

    unless session[:authenticated_album_id] == @album.id
      redirect_to album_access_path(@album), alert: 'Mot de passe requis'
      return
    end

    @client = @album.client
    @images = @album.images.with_attached_photo.order(created_at: :desc)

    # 👇 invitation management
    invitation_management
  end

  def invitation_management
    @brochure =
      @client.brochures
        .where(kind: 'invitation')
        .last

    return unless @brochure

    @guest_stats = @brochure.guest_stats
    @tables = @brochure.table_distribution
    @new_guest = @brochure.invitation_guests.new
  end

  def checkin
    guest = InvitationGuest.find_by!(token: params[:token])

    unless guest.accepted?
      return render json: {
        error: 'Invité non confirmé'
      }, status: :unprocessable_entity
    end

    if guest.checked_in?
      return render json: {
        already: true,
        name: guest.name,
        table: guest.table,
        time: guest.checked_in_at
      }
    end

    guest.update!(
      checked_in_at: Time.current
    )

    render json: {
      success: true,
      name: guest.name,
      table: guest.table
    }
  end

  def admin_access
    authorize @album if respond_to?(:authorize)
    @album = Album.friendly.find(params[:id])

    unless current_user.super_admin? 
      redirect_to album_access_path(@album), alert: "Accès non autorisé"
      return
    end
    session[:authenticated_album_id] = @album.id

    redirect_to album_gallery_path(@album)
  end
end
