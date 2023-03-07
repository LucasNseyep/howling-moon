class Thought < ApplicationRecord
  belongs_to :user
  belongs_to :collection
  # has_many :connections

  has_one :parent_relationship, foreign_key: :child_id, class_name: 'Connection'
  has_one :parent, through: :parent_relationship, source: :parent

  has_many :child_relationships, foreign_key: :parent_id, class_name: 'Connection'
  has_many :children, through: :child_relationships, source: :child

  # # has_one :parent, through: :parent_relationship, source: :parent

  # has_many :child_relationships, foreign_key: :child_id, class_name: 'Connection'
  # has_many :children, through: :child_relationships, source: :children

  def connect(thought_id)
    Connection.create!(parent_id: thought_id, child_id: id)
  end

  def disconnect(thought_id)
    Connection.find_by(parent_id: thought_id.to_i, child_id: id).destroy
  end

  def is_connected?(thought_id)
    relationship = Connection.find_by(parent_id: thought_id.to_i, child_id: id)
    return true if relationship
  end

end
