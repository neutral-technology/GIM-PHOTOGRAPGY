class BackfillPhotographerOnReceipts < ActiveRecord::Migration[7.0]
  def up
    photographer = Photographer.first || Photographer.create!(name: "Default", active: true)

    Receipt.where(photographer_id: nil)
          .update_all(photographer_id: photographer.id)
  end
end
