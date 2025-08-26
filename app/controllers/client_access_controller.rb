class ClientAccessController < ApplicationController
  layout 'default' # applies to all actions

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
      flash.now[:alert] = "Incorrect password."
      render :show, status: :unauthorized
    end
  end
  
  # This action displays the actual gallery after successful authentication
  def gallery
    @album = Album.friendly.find(params[:id])
    # Check if the user is authorized to view this album
    unless session[:authenticated_album_id] == @album.id
      redirect_to album_access_path(@album), alert: "Please enter the password to view this album."
    end
    @images = @album.images.with_attached_photo.order(created_at: :desc)
  end
end