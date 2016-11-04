class CreateTableIngredients < ActiveRecord::Migration
  
  def up
    create_table :ingredients do |t|
      t.string :name, limit: 10, null: false
      t.integer :recipe_id, null: false
      t.string :amount, null: false, limit: 10
    end

    add_foreign_key :ingredients, :recipes, column: :recipe_id

  end

  def down
    drop_table :ingredients
  end
end
