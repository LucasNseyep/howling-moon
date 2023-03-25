class Collection < ApplicationRecord
  # has_and_belongs_to_many :thoughts
  has_one :user, through: :thought
  # validates :title, presence: true, uniqueness: true
  # has_and_belongs_to_many :thoughts, dependent: :nullify
  has_many :thoughts, dependent: :nullify

  validates :title, presence: true, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search_by_title_and_description,
                  against: %i[title description],
                  using: {
                    tsearch: { prefix: true }
                  }
end
