# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require './models/favor'
require './models/follow'
require './models/ingredient'
require './models/recipe'
require './models/step'
require './models/user'



# adding seeds

User.create(name: "user1", password: "111111", create_time: 1475280000)
User.create(name: "user2", password: "111111", create_time: 1475280000)
User.create(name: "user3", password: "111111", create_time: 1475280000)
User.create(name: "user4", password: "111111", create_time: 1475280000)
User.create(name: "user5", password: "111111", create_time: 1475280000)

Follow.create(follower_id: 1, followed_id: 2)
Follow.create(follower_id: 1, followed_id: 3)
Follow.create(follower_id: 1, followed_id: 4)
Follow.create(follower_id: 1, followed_id: 5)
Follow.create(follower_id: 2, followed_id: 1)
Follow.create(follower_id: 2, followed_id: 3)
Follow.create(follower_id: 2, followed_id: 4)
Follow.create(follower_id: 2, followed_id: 5)
Follow.create(follower_id: 3, followed_id: 1)
Follow.create(follower_id: 3, followed_id: 2)
Follow.create(follower_id: 3, followed_id: 4)
Follow.create(follower_id: 3, followed_id: 5)
Follow.create(follower_id: 4, followed_id: 1)
Follow.create(follower_id: 4, followed_id: 2)
Follow.create(follower_id: 5, followed_id: 3)
Follow.create(follower_id: 5, followed_id: 4)

Recipe.create(name: "recipe1", user_id: 1, create_time: 1475280000)
Recipe.create(name: "recipe2", user_id: 1, create_time: 1475280000)
Recipe.create(name: "recipe3", user_id: 2, create_time: 1475280000)
Recipe.create(name: "recipe4", user_id: 2, create_time: 1475280000)
Recipe.create(name: "recipe5", user_id: 3, create_time: 1475280000)
Recipe.create(name: "recipe6", user_id: 4, create_time: 1475280000)
Recipe.create(name: "recipe7", user_id: 5, create_time: 1475280000)

Favor.create(user_id: 1, recipe_id: 3)
Favor.create(user_id: 1, recipe_id: 5)
Favor.create(user_id: 2, recipe_id: 1)
Favor.create(user_id: 2, recipe_id: 6)
Favor.create(user_id: 3, recipe_id: 2)
Favor.create(user_id: 4, recipe_id: 4)
Favor.create(user_id: 5, recipe_id: 1)

Ingredient.create(name: "beef", recipe_id: 1, amount: "50g")
Ingredient.create(name: "powder", recipe_id: 1, amount: "50g")
Ingredient.create(name: "vegetable", recipe_id: 1, amount: "50g")

Step.create(recipe_id: 1, index: 1, content: "cook beef")
Step.create(recipe_id: 1, index: 2, content: "cook powder")
Step.create(recipe_id: 1, index: 3, content: "cook vegetable")