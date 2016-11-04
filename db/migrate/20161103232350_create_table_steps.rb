class CreateTableSteps < ActiveRecord::Migration
  def up
    create_table :steps do |t|
      t.integer :recipe_id, null: false
      t.integer :index, null: false # the index of the step in the recipe
      t.string :content, null: false, limit: 30
    end

    add_foreign_key :steps, :recipes, column: :recipe_id
  end

  def down
    drop_table :steps
  end
end
