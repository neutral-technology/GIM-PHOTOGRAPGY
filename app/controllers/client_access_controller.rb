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
      flash.now[:alert] = 'Incorrect password.'
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
  end
end
