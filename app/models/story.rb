class Story < ApplicationRecord
  has_many :chats, dependent: :destroy
end
