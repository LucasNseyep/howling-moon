class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.integer 'parent_id', null: false
      t.integer 'child_id', null: false

      t.timestamps
    end
    
    add_index :connections, :parent_id
    add_index :connections, :child_id
    add_index :connections, [:parent_id, :child_id], unique: true
  end
end
