class ImagesController < ApplicationController
  layout 'default'
  before_action :authenticate_user!

  def create
    @album = current_user.albums.friendly.find(params[:album_id])
    if image_params[:photo].present?
      new_images = image_params[:photo].compact_blank.map do |p|
        @album.images.create!(photo: p)
      end
      # New Logic: Automatically set a cover photo if one doesn't exist
      if !@album.cover_photo.attached? && new_images.any?
        random_image = new_images.sample
        @album.cover_photo.attach(random_image.photo.blob)
      end
      redirect_to @album, notice: 'Images were successfully added.'
    else
      redirect_to @album, alert: 'Failed to add images.'
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @album, alert: "Failed to add images: #{e.message}"
  end

  private

  def image_params
    params.require(:image).permit(photo: [])
  end
end
