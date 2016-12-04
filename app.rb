require 'sinatra'
require 'active_record'
require 'algorithms'
require 'jwt'
require 'cloudinary'
require './config/environments'
require './config/properties'

require './models/favor'
require './models/follow'
require './models/ingredient'
require './models/recipe'
require './models/step'
require './models/user'

require './lib/errors'
require './lib/result'
require './lib/userutil'
require './lib/recipeutil'
require './lib/favorutil'

require 'byebug'

include Error
include Api
include UserUtil
include RecipeUtil
include FavorUtil

get '/' do
  redirect "test.html"
end

# no authentication
post '/api/v1/users/login' do
  @json = JSON.parse request.body.read
  p @json
  username = @json["username"]
  password = @json["password"]
  begin
    user = UserUtil::authenticate username, password
    token = UserUtil::generate_token user
    Api::Result.new(true, {access_token: token, user_id: user.id}).to_json
  rescue Error::AuthError => e
    Api::Result.new(false, e.message).to_json
  end
end

# no authentication
# parameters: {username: "", password: "", password2: ""}
post '/api/v1/users' do
  @json = JSON.parse request.body.read
  begin
    user = UserUtil::create_new_user @json
    token = UserUtil::generate_token user
    Api::Result.new(true, {access_token: token}).to_json
  rescue Error::SignUpError => e
    Api::Result.new(false, e.message).to_json
  end
end

# authentication required
# parameters: none
get "/api/v1/users/:id" do
  user_id = params[:id]
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    user = UserUtil::find_user_by_id user_id
    is_following = UserUtil::is_following active_user.id, user_id
    Api::Result.new(true, {user: user.to_json_obj, is_following: is_following}).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
# parameters: {old_password: "", new_password: "", new_password2: ""}
put '/api/v1/users/changepassword' do
  begin
    @json = JSON.parse request.body.read
    p @json
    token = @json["access_token"]
    old_password = @json["old_password"]
    new_password = @json["new_password"]
    new_password2 = @json["new_password2"]
    active_user = UserUtil::check_token token
    UserUtil::change_password active_user, old_password, new_password, new_password2
    Api::Result.new(true, "Password changed.").to_json
  rescue Error::ChangePasswdError => e
    Api::Result.new(false, e.message).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
# parameters: none
get '/api/v1/users/:id/followings' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    user_id = params[:id]
    user_list = UserUtil::get_following_user_list user_id
    Api::Result.new(true, {followings: user_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
# parameters: none
get '/api/v1/users/:id/followers' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    user_id = params[:id]
    user_list = UserUtil::get_follower_user_list user_id
    Api::Result.new(true, {followers: user_list}).to_json
  rescue Error::FollowError 
  rescue JWT::DecodeError
    401
  end
end

# authentication required
# parameters: following_id
post '/api/v1/follows' do
  @json = JSON.parse request.body.read
  begin
    token = @json["access_token"]
    following_id = @json["following_id"].to_i
    user = UserUtil::check_token token
    UserUtil::add_follow_relation user.id, following_id
    Api::Result.new(true, "New Relationship added.").to_json
  rescue ActiveRecord::InvalidForeignKey
    Api::Result.new(false, "There is no such user").to_json
  rescue Error::FollowError => e
    Api::Result.new(false, e.message).to_json
  rescue JWT::DecodeError 
    401
  end
end

# authentication required
post '/api/v1/follows/delete' do
  @json = JSON.parse request.body.read
  begin
    token = @json["access_token"]
    following_id = @json["following_id"].to_i
    user = UserUtil::check_token token
    UserUtil::delete_follow_relation user.id, following_id
    Api::Result.new(true, "Relationship deleted.").to_json
  rescue Error::FollowError => e
    Api::Result.new(false, e.message).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
# params: recipe_name: "", recipe_file: file file can be empty
#         ingredients: json string of an array [{name: "", amount: ""},{}]
#         steps: the number of steps
#         steps_text: json string of an array ["step1 text", "step2 text"]
#         steps_file1: file, steps_file2: file   (the number of <k,v>pairs is "steps")
post '/api/v2/recipes' do
  token = params[:access_token]
  begin
    user = UserUtil::check_token token
    recipe = RecipeUtil::create_new_recipe2 user.id, user.name, params
    Api::Result.new(true, {recipe: recipe.to_json_obj}).to_json
  rescue JWT::DecodeError
    401
  end
end


# authentication required
post '/api/v3/recipes' do
  @json = JSON.parse request.body.read
  p @json
  begin
    token = @json["access_token"]
    user = UserUtil::check_token token
    recipe = RecipeUtil::create_new_recipe3 user, @json
    Api::Result.new(true, {recipe: recipe.to_json_obj}).to_json
  rescue JWT::DecodeError
    401
  end
end


# authentication required
# parameters: none
get '/api/v1/users/:id/recipes' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    user_id = params[:id]
    recipe_list = RecipeUtil::get_time_line user_id
    recipe_list = FavorUtil::mark_favor_on_recipes active_user.id, recipe_list
    Api::Result.new(true, {recipes: recipe_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
get '/api/v1/recipes/:id' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    recipe_id = params[:id]
    recipe = RecipeUtil::get_recipe_by_id recipe_id
    is_favored = FavorUtil::is_favor active_user.id, recipe_id
    ingredients = RecipeUtil::get_ingredients_by_recipeid recipe_id
    steps = RecipeUtil::get_steps_by_recipeid recipe_id
    Api::Result.new(true, {recipe: recipe, is_favored: is_favored, ingredients: ingredients, steps: steps}).to_json
  rescue JWT::DecodeError
    401
  rescue ActiveRecord::RecordNotFound
    status 500
    body "Record Not Found"
  end
end

# authentication required
# parameters: none
get '/api/v1/homeline' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    recipe_list = RecipeUtil::get_home_line active_user.id
    recipe_list = FavorUtil::mark_favor_on_recipes active_user.id, recipe_list
    Api::Result.new(true, {recipes: recipe_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
post '/api/v1/favors' do
  @json = JSON.parse request.body.read
  begin
    token = @json["access_token"]
    user = UserUtil::check_token token
    recipe_id = @json["recipe_id"]
    FavorUtil::add_favor user.id, recipe_id
    Api::Result.new(true, "Recipe added to favor list.").to_json
  rescue ActiveRecord::InvalidForeignKey
    Api::Result.new(false, "There is no such recipe").to_json
  rescue Error::FavorError => e
    Api::Result.new(false, e.message).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
post '/api/v1/favors/delete' do
  @json = JSON.parse request.body.read
  begin
    token = @json["access_token"]
    recipe_id = @json["recipe_id"]
    user = UserUtil::check_token token
    FavorUtil::delete_favor user.id, recipe_id
    Api::Result.new(true, "Recipe has been unfavored.").to_json
  rescue Error::FavorError => e
    Api::Result.new(false, e.message).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
get '/api/v1/favors' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    recipe_list = FavorUtil::get_favors active_user
    Api::Result.new(true, {recipes: recipe_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

#authentication required
post '/api/v1/recipe_picture' do
  token = params[:access_token]
  p params
  begin
    active_user = UserUtil::check_token token
    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
      return Api::Result.new(false, "No picture selected.").to_json
    end
    url = "uploads/user#{active_user.id}recipe#{Time.now.to_i}.#{name.split('.')[1]}"
    path = "public/#{url}"
    File.open(path, "wb") { |file| file.write tmpfile.read}
    Api::Result.new(true, {url: url}).to_json
  rescue JWT::DecodeError
    401
  end
end

post '/api/v2/recipe_picture' do
  p request
  unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
    return Api::Result.new(false, "No picture selected.").to_json
  end
  p tmpfile
  url = "uploads/recipe#{Time.now.to_i}.#{name.split('.')[1]}"
  path = "public/#{url}"
  File.open(path, "wb") { |file| file.write tmpfile.read}
  Api::Result.new(true, {url: "http://kitchen-in-pocket.herokuapp.com/#{url}"}).to_json
end
