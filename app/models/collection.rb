class Collection < ApplicationRecord
  has_many :thoughts
  has_one :user, through: :thoughts
  # validates :title, presence: true, uniqueness: true
  has_many :thoughts, dependent: :nullify
end
