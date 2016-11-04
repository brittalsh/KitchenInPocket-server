class CreateTableRecipes < ActiveRecord::Migration
  def up
    create_table :recipes do |t|
      t.string :name, limit: 15, null: false
      t.integer :create_time, limit: 8, null: false
    end
  end

  def down
    drop_table :users
  end

end