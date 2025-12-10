# app/jobs/delete_expired_images_job.rb
class DeleteExpiredImagesJob < ApplicationJob
  queue_as :default

  def perform
    Image.where.not(downloaded_at: nil).find_each do |image|
      if image.expired?
        image.photo.purge
        image.destroy # optional if you want to delete the DB record too
      end
    end
  end
end
