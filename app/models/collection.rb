class Collection < ApplicationRecord
  has_many :thoughts
  # validates :title, presence: true, uniqueness: true
end
