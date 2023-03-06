class Connection < ApplicationRecord
  belongs_to :parent, foreign_key: :parent_id, class_name: 'Thought'
  belongs_to :child, foreign_key: :child_id, class_name: 'Thought'
end
