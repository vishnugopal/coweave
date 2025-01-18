class Story < ApplicationRecord
  has_many :playthroughs, dependent: :destroy
end
