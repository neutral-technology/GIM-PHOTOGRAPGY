class BrochureBlock < ApplicationRecord
  belongs_to :brochure_page

  has_one_attached :image

  enum block_type: {
    title: "title",
    paragraph: "paragraph",
    image: "image"
  }
end
