class Favor < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :recipe

  validates_uniqueness_of :recipe_id, {scope: [:user_id], message: "This is already a favored recipe."}

end