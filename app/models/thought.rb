class Thought < ApplicationRecord
  belongs_to :user
  # belongs_to :collection

  #Tis section makes subtables of connections for parents and children
  #https://3rd-edition.railstutorial.org/book/following_users#fig-user_has_many_followers
  has_one :parent_relationship, foreign_key: :child_id, class_name: 'Connection'
  has_one :parent, through: :parent_relationship, source: :parent

  has_many :child_relationships, foreign_key: :parent_id, class_name: 'Connection'
  has_many :children, through: :child_relationships, source: :child

  #Connects the card you select as a parent. We do this by going to the parent and
  #making the current card its child.
  def connect(thought_id)
    child_relationships.create!(child_id: thought_id)
  end

  #Disconnects the card you select as a parent. We do this by going to the parent and
  #making the current card its child.
  def disconnect(thought_id)
    child_relationships.find_by(parent_id: id, child_id: thought_id).destroy
  end

  def is_connected?(thought_id)
    relationship = Connection.find_by(parent_id: id, child_id: thought_id)
    return true if relationship
  end

end
