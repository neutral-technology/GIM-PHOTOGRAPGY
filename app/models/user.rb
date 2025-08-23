class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ADJECTIVES = %w[Quick Happy Silent Brave Clever Sleepy Noisy Blue Red Fuzzy
                  Lazy Bright Swift Kind Shy Grumpy Loud Tiny Gentle Wild Proud
                  Jolly Smart Zany Sunny Mellow Cheeky Sneaky
                ]
  ANIMALS = %w[Sparrow Robin Falcon Eagle Owl Hawk Parrot Pigeon Pelican Heron
                Swallow Stork Woodpecker Kingfisher Duck Goose Crow Magpie Seagull Crane
                Peacock Flamingo Canary Lark Humming Finch Kite Nightingale Tern Jay
                Lion Tiger Bear Fox Wolf Owl Panda Falcon Rabbit Eagle
              ]


           # Add validations for new fields if necessary
  validates :full_name, presence: true, length: { maximum: 25 }
  validates :city, length: { maximum: 15 }, allow_blank: true # Optional: allow blank if not mandatory

  # Callback to generate a unique ID before creating a new user
  before_create :generate_unique_id

  private

  def generate_unique_id
    # Use SecureRandom.uuid for a universally unique identifier
    # Loop until a unique ID is found, though UUID collisions are extremely rare
    loop do
      adjective = ADJECTIVES.sample
      animal = ANIMALS.sample
      number = rand(10..99)
      self.unique_id = "#{adjective}#{animal}#{number}"
      break unless User.exists?(unique_id: unique_id)
    end
  end
end
