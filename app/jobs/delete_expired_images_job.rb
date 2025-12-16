# app/jobs/delete_expired_images_job.rb
class DeleteExpiredImagesJob < ApplicationJob
  queue_as :default

  def perform
    Image.where.not(downloaded_at: nil)
      .where(downloaded_at: ..48.hours.ago) # DEV TEST
      .find_each do |image|
      image.photo.purge
      image.destroy
    end
  end
end
