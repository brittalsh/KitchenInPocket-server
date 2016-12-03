module FavorUtil

  def add_favor user_id, recipe_id
    favor = Favor.new
    favor.user_id = user_id
    favor.recipe_id = recipe_id
    raise Error::FavorError, favor.errors.messages.values[0][0] unless favor.save
  end

  def delete_favor user_id, recipe_id
    favor = Favor.find_by(user_id: user_id, recipe_id: recipe_id)
    raise Error::FavorError, "Cannot unfavor an unfavored tweet." if favor == nil
    favor.destroy
  end

end