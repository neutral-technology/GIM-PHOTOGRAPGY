class ImagesController < ApplicationController
  layout 'default'

  before_action :authenticate_user!, except: [:mark_downloaded]
  before_action :set_album, only: [:create]
  before_action :set_image, only: %i[mark_downloaded destroy]

  def create
    authorize @album, :update? # 🔥 owner or admin only

    if image_params[:photo].present?
      new_images = image_params[:photo].compact_blank.map do |p|
        @album.images.create!(photo: p)
      end

      if !@album.cover_photo.attached? && new_images.any?
        random_image = new_images.sample
        @album.cover_photo.attach(random_image.photo.blob)
      end

      redirect_to @album, notice: 'Images were successfully added.'
    else
      redirect_to @album, alert: 'Echec de sauvegarde.'
    end
  end

  def destroy
    album = @image.album
    authorize album, :update? # 🔥 NOT @image

    @image.destroy
    redirect_to album, notice: 'Image suprimée.'
  end

  def mark_downloaded
    album = @image.album

    # 🔥 allow:
    # - public album
    # - authenticated via password
    # - owner/admin
    unless album.public? ||
           session[:authenticated_album_id] == album.id ||
           (user_signed_in? && (album.user_id == current_user.id || current_user.super_admin?))
      head :unauthorized
      return
    end

    @image.mark_downloaded!
    head :ok
  end

  private

  def set_album
    @album = Album.friendly.find(params[:album_id]) # ✅ no current_user here
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(photo: [])
  end
end
