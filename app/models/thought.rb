class Thought < ApplicationRecord
  belongs_to :user
  belongs_to :collection, optional: true

  # Tis section makes subtables of connections for parents and children
  # https://3rd-edition.railstutorial.org/book/following_users#fig-user_has_many_followers
  has_one :parent_relationship, foreign_key: :child_id, class_name: 'Connection'
  has_one :parent, through: :parent_relationship, source: :parent

  has_many :child_relationships, foreign_key: :parent_id, class_name: 'Connection'
  has_many :children, through: :child_relationships, source: :child

  validates :form_is_filled, presence: true, if: :form_is_filled

  # SEARCH STUFF IMPLEMENTATION
  # PgSearch::Multisearch.rebuild(Thought)
  include PgSearch::Model
  pg_search_scope :search,
                  against: %i[title content],
                  associated_against: {
                    collection: %i[title description]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  # Connects the card you select as a parent. We do this by going to the parent and
  # making the current card its child.
  def connect(thought_id)
    child_relationships.create!(child_id: thought_id)
  end

  # Disconnects the card you select as a parent. We do this by going to the parent and
  # making the current card its child.
  def disconnect(thought_id)
    child_relationships.find_by(parent_id: id, child_id: thought_id).destroy
  end

  # def disconnect_from_collection(param_thought)
  #   param_thought.destroy
  # end

  def is_connected?(thought_id)
    relationship = Connection.find_by(parent_id: id, child_id: thought_id)
    return true if relationship
  end

  def root
    thought = self
    return thought if thought.parent.nil?

    thought = thought.parent until thought.parent.nil?
    return thought
  end

  def ancestors
    thought = self
    path = []

    until thought.parent.nil?
      thought = thought.parent
      path.append(thought)
    end
    return path.reverse
  end

  def path
    return ancestors.append(self)
  end

  # Can we refactor to use join of Thoughts and Connection models
  def self.roots
    roots = []
    Thought.all.each do |thought|
      roots.append(thought) if thought.parent.nil?
    end
    return roots
  end

  private

  def form_is_filled
    title || content
  end
end
