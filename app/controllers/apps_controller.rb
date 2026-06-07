class AppsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  def index
    @apps = Album.all
    skip_policy_scope # This tells Pundit to stop complaining for this action
    # Find the specific album named "GIM" to use for the homepage carousel
    @carousel_album = Album.find_by(name: 'GIM')
    # If the album is found, get its images
    @carousel_images = if @carousel_album
                         @carousel_album.images.with_attached_photo.order(created_at: :desc)
                       else
                         [] # Ensure it's an empty array if the album is not found
                       end
    @tarifs = current_user&.tarifs&.order(:service)
    render layout: 'default', template: 'apps/index'
  end
end
