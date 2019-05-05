class Team < ApplicationRecord
  belongs_to :user
  belongs_to :season
  has_many :drafts
  has_many :players, through: :drafts
  has_many :games, class_name: 'Game', foreign_key: :home_team
  has_many :games, class_name: 'Game', foreign_key: :away_team
  has_many :statistics, through: :games

  validates :name, presence: true, uniqueness: { scope: :season }
  validates :main_colour, presence: true
  validates :secondary_colour, presence: true
  validates [:main_colour, :secondary_colour], uniqueness: { scope: :season }

  enum status: { recruiting: 0, complete: 1 }
end