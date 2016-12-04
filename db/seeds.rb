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

Recipe.create(name: "recipe1", user_id: 1, user_name: "user1", create_time: 1475280000, picture: "uploads/832e.jpg", likes: 0)
Recipe.create(name: "recipe2", user_id: 1, user_name: "user2", create_time: 1475280000, picture: "uploads/832e.jpg", likes: 0)
Recipe.create(name: "recipe3", user_id: 2, user_name: "user3", create_time: 1475280000, picture: "uploads/832e.jpg", likes: 0)
Recipe.create(name: "recipe4", user_id: 2, user_name: "user4", create_time: 1475280000, picture: "uploads/832e.jpg", likes: 0)
Recipe.create(name: "recipe5", user_id: 3, user_name: "user5", create_time: 1475280000, picture: "uploads/832e.jpg", likes: 0)
Recipe.create(name: "recipe6", user_id: 4, user_name: "user6", create_time: 1475280000, picture: "uploads/832e.jpg", likes: 0)
Recipe.create(name: "recipe7", user_id: 5, user_name: "user7", create_time: 1475280000, picture: "uploads/832e.jpg", likes: 0)

Favor.create(user_id: 1, recipe_id: 3)
Favor.create(user_id: 1, recipe_id: 5)
Favor.create(user_id: 2, recipe_id: 1)
Favor.create(user_id: 2, recipe_id: 6)
Favor.create(user_id: 3, recipe_id: 2)
Favor.create(user_id: 4, recipe_id: 4)
Favor.create(user_id: 5, recipe_id: 1)

Ingredient.create(name: "apple", recipe_id: 1, amount: "50g")
Ingredient.create(name: "banana", recipe_id: 1, amount: "50g")
Ingredient.create(name: "mac", recipe_id: 1, amount: "50g")

Ingredient.create(name: "apple", recipe_id: 2, amount: "50g")
Ingredient.create(name: "banana", recipe_id: 2, amount: "50g")
Ingredient.create(name: "mac", recipe_id: 2, amount: "50g")

Ingredient.create(name: "apple", recipe_id: 3, amount: "50g")
Ingredient.create(name: "banana", recipe_id: 3, amount: "50g")
Ingredient.create(name: "mac", recipe_id: 3, amount: "50g")

Ingredient.create(name: "apple", recipe_id: 4, amount: "50g")
Ingredient.create(name: "banana", recipe_id: 4, amount: "50g")
Ingredient.create(name: "mac", recipe_id: 4, amount: "50g")

Ingredient.create(name: "apple", recipe_id: 5, amount: "50g")
Ingredient.create(name: "banana", recipe_id: 5, amount: "50g")
Ingredient.create(name: "mac", recipe_id: 5, amount: "50g")

Ingredient.create(name: "apple", recipe_id: 6, amount: "50g")
Ingredient.create(name: "banana", recipe_id: 6, amount: "50g")
Ingredient.create(name: "mac", recipe_id: 6, amount: "50g")

Ingredient.create(name: "apple", recipe_id: 7, amount: "50g")
Ingredient.create(name: "banana", recipe_id: 7, amount: "50g")
Ingredient.create(name: "mac", recipe_id: 7, amount: "50g")

Step.create(recipe_id: 1, index: 1, content: "recipe 1 step 1", picture: "uploads/832e.jpg")
Step.create(recipe_id: 1, index: 2, content: "recipe 1 step 2", picture: "uploads/832e.jpg")
Step.create(recipe_id: 1, index: 3, content: "recipe 1 step 3", picture: "uploads/832e.jpg")

Step.create(recipe_id: 2, index: 1, content: "recipe 2 step 1", picture: "uploads/832e.jpg")
Step.create(recipe_id: 2, index: 2, content: "recipe 2 step 2", picture: "uploads/832e.jpg")
Step.create(recipe_id: 2, index: 3, content: "recipe 2 step 3", picture: "uploads/832e.jpg")

Step.create(recipe_id: 3, index: 1, content: "recipe 3 step 1", picture: "uploads/832e.jpg")
Step.create(recipe_id: 3, index: 2, content: "recipe 3 step 2", picture: "uploads/832e.jpg")
Step.create(recipe_id: 3, index: 3, content: "recipe 3 step 3", picture: "uploads/832e.jpg")

Step.create(recipe_id: 4, index: 1, content: "recipe 3 step 1", picture: "uploads/832e.jpg")
Step.create(recipe_id: 4, index: 2, content: "recipe 3 step 2", picture: "uploads/832e.jpg")
Step.create(recipe_id: 4, index: 3, content: "recipe 3 step 3", picture: "uploads/832e.jpg")

Step.create(recipe_id: 5, index: 1, content: "recipe 3 step 1", picture: "uploads/832e.jpg")
Step.create(recipe_id: 5, index: 2, content: "recipe 3 step 2", picture: "uploads/832e.jpg")
Step.create(recipe_id: 5, index: 3, content: "recipe 3 step 3", picture: "uploads/832e.jpg")

Step.create(recipe_id: 6, index: 1, content: "recipe 3 step 1", picture: "uploads/832e.jpg")
Step.create(recipe_id: 6, index: 2, content: "recipe 3 step 2", picture: "uploads/832e.jpg")
Step.create(recipe_id: 6, index: 3, content: "recipe 3 step 3", picture: "uploads/832e.jpg")

Step.create(recipe_id: 7, index: 1, content: "recipe 3 step 1", picture: "uploads/832e.jpg")
Step.create(recipe_id: 7, index: 2, content: "recipe 3 step 2", picture: "uploads/832e.jpg")
Step.create(recipe_id: 7, index: 3, content: "recipe 3 step 3", picture: "uploads/832e.jpg")
