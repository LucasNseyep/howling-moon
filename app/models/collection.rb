class Collection < ApplicationRecord
  has_many :thoughts
  has_one :user, through: :thoughts
  # validates :title, presence: true, uniqueness: true
  has_many :thoughts, dependent: :nullify

  include PgSearch::Model
  pg_search_scope :search_collection,
  against: [ :title, :description ],
  associated_against: {
    thought: [ :title, :content  ]
  },
  using: {
    tsearch: { prefix: true}
  }
end
