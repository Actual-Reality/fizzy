class Project < ApplicationRecord
  belongs_to :account
  has_many :cards
  has_many :time_entries, through: :cards

  validates :name, presence: true
end
