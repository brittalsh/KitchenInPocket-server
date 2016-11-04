class CreateTableFavors < ActiveRecord::Migration
  def up
    create_table :favors do |t|
      t.integer :user_id, null: false
      t.integer :recipe_id, null: false
    end

    add_foreign_key :favors, :users, column: :user_id
    add_foreign_key :favors, :recipes, column: :recipe_id
  end

  def down
    drop_table :favors
  end
end
