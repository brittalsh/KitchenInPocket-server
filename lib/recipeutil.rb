module RecipeUtil

  class RecipeList
    # ActiveRecord::Relation
    attr_accessor :recipes_relation

    def initialize recipes
      @recipes_relation = recipes
    end

    def to_json_obj fields = nil
      list = [];
      @recipes_relation.each do |recipe_record|
        list.push(recipe_record.to_json_obj fields)
      end
      list
    end
  end

  def create_new_recipe user_id, recipe_name, recipe_ingredients, recipe_ingredient_amounts, recipe_steps
    recipe = Recipe.new
    recipe.name = recipe_name
    recipe.create_time = Time.now().to_i
    recipe.user_id = user_id
    raise Error::CreateRecipeError, recipe.errors.messages.values[0][0] unless recipe.save

    recipe_ingredients.length.times do |i|
      Ingredient.create(name: recipe_ingredients[i], recipe_id: recipe.id, amount: recipe_ingredient_amounts[i])
    end

    recipe_steps.length.times { |i| Step.create(recipe_id: recipe.id, index: i + 1, content: recipe_steps[i])}

    recipe
  end

  def get_time_line user_id
    recipe_list = RecipeList.new User.find(user_id).recipes
    recipe_list.to_json_obj
  end

  def get_home_line user_id
    userid_list = []
    Follow.select("followed_id").where("follower_id = ?", user_id).each { |follow| userid_list.push follow.followed_id }
    userid_list.push user_id
    recipe_list = RecipeList.new Recipe.where(user_id: userid_list)
    recipe_list.to_json_obj
  end
end