class ImagesController < ApplicationController
 layout 'default'
  before_action :authenticate_user!

  def create
    @album = current_user.albums.friendly.find(params[:album_id])
    if image_params[:photo].present?
      image_params[:photo].compact_blank.each do |p|
        @album.images.create!(photo: p)
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