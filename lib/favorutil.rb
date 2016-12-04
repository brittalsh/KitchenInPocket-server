require 'set'
module FavorUtil

  def add_favor user_id, recipe_id
    favor = Favor.new
    favor.user_id = user_id
    favor.recipe_id = recipe_id
    raise Error::FavorError, favor.errors.messages.values[0][0] unless favor.save
    recipe = Recipe.find recipe_id
    recipe.update(likes: recipe.likes + 1)
  end

  def delete_favor user_id, recipe_id
    favor = Favor.find_by(user_id: user_id, recipe_id: recipe_id)
    raise Error::FavorError, "Cannot unfavor an unfavored tweet." if favor == nil
    favor.destroy
    recipe = Recipe.find recipe_id
    recipe.update(likes: recipe.likes - 1)
  end

  def get_favors user
    recipe_list = []
    user.favored_recipes.each { |recipe| recipe_list.push recipe.to_json_obj }
    recipe_list
  end

  def mark_favor_on_recipes user_id, recipe_list
    id_set = Set.new
    Favor.select("recipe_id").where(user_id: user_id).each { |favor| id_set.add favor.recipe_id }
    recipe_list.each do |recipe|
      recipe["is_favored"] = (id_set.include? recipe["id"])
    end
    recipe_list
  end

  def is_favor user_id, recipe_id
    favor = Favor.find_by(user_id: user_id, recipe_id: recipe_id)
    return false if favor == nil
    true
  end
end