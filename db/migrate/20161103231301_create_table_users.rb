class CreateTableUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name, limit: 20, null: false, index: {unique: true}
      t.string :password, limit: 20, null: false
      t.integer :create_time, limit: 8, null: false
      t.string :intro, limit: 50
    end
  end

  def down
    drop_table :users
  end
end