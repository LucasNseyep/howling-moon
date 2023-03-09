class Collection < ApplicationRecord
  # validates :title, presence: true, uniqueness: true
  has_many :thoughts, dependent: :nullify
end
