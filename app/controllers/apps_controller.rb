class AppsController < ApplicationController
  def index
    # Find the specific album named "GIM" to use for the homepage carousel
    @carousel_album = Album.find_by(name: "GIM")
    # If the album is found, get its images
    if @carousel_album
      @carousel_images = @carousel_album.images.with_attached_photo.order(created_at: :desc)
    else
      @carousel_images = [] # Ensure it's an empty array if the album is not found
    end
    render layout: 'default', template: 'apps/index'
  end
end
