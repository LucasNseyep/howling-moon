class Connection < ApplicationRecord
  belongs_to :parent, class_name: 'Thought'
  belongs_to :child, class_name: 'Thought'
end
