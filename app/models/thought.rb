class Thought < ApplicationRecord
  belongs_to :user
  belongs_to :collection
  # has_many :connections

  has_one :parent_relationship, foreign_key: :child_id, class_name: 'Connection'
  has_one :parent, through: :parent_relationship, source: :parent

  has_many :child_relationships, foreign_key: :parent_id, class_name: 'Connection'
  has_many :children, through: :child_relationships, source: :child

  def connect(thought_id)
    child_relationships.create!(child_id: thought_id)
  end

  def disconnect(thought_id)
    child_relationships.find_by(parent_id: id, child_id: thought_id).destroy
  end

  def is_connected?(thought_id)
    relationship = Connection.find_by(parent_id: id, child_id: thought_id)
    return true if relationship
  end

end
