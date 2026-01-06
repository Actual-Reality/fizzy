class Project < ApplicationRecord
  belongs_to :account
  has_many :cards, dependent: :nullify
  has_many :time_entries, through: :cards

  validates :name, presence: true
end
