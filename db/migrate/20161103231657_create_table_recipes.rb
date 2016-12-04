class CreateTableRecipes < ActiveRecord::Migration
  def up
    create_table :recipes do |t|
      t.string :name, limit: 30, null: false
      t.integer :user_id, null: false
      t.string :user_name, limit: 20, null: false
      t.text :picture
      t.integer :create_time, limit: 8, null: false
      t.integer :likes, default: 0, null: false
    end

    add_foreign_key :recipes, :users, column: :user_id
  end

  def down
    drop_table :users
  end

end