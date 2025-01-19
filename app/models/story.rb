class Story < ApplicationRecord
  has_many :playthroughs, dependent: :destroy

  # Extracts scenes from the story text
  def scenes
    [ "Start" ] + text.scan(/#+.*?Scene.*?\d+.*?: (.*)?$/i).flatten
  end

  def scene_count
    scenes.count - 1
  end
end
