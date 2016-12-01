require 'sinatra'
require 'active_record'
require 'jwt'
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

require 'byebug'

include Error
include Api
include UserUtil
include RecipeUtil

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
    Api::Result.new(true, {user: user.to_json_obj}).to_json
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
  rescue JWT::DecodeError
    401
  end
end

# authentication required
# parameters: name, ingredients(array), ingredient_amounts(array), steps(array)
post '/api/v1/recipes' do
  begin
    @json = JSON.parse request.body.read
    token = @json["access_token"]
    recipe_name = @json["name"]
    recipe_ingredients = @json["ingredients"]
    recipe_ingredient_amounts = @json["ingredient_amounts"]
    recipe_steps = @json["steps"]
    user = UserUtil::check_token token
    recipe = RecipeUtil::create_new_recipe user.id, recipe_name, recipe_ingredients, recipe_ingredient_amounts, recipe_steps
    Api::Result.new(true, {recipe: recipe.to_json_obj}).to_json
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
    recipe = RecipeUtil::create_new_recipe2 user.id, params
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
    Api::Result.new(true, {recipes: recipe_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

# authentication required
# parameters: none
get '/api/v1/homeline' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    recipe_list = RecipeUtil::get_home_line active_user.id
    Api::Result.new(true, {recipes: recipe_list}).to_json
  rescue JWT::DecodeError
    401
  end
end

#authentication required
post '/api/v1/file_upload' do
  token = params[:access_token]
  begin
    active_user = UserUtil::check_token token
    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
      return "No file selected"
    end
    puts "Uploading file, original name #{name.inspect}"
    path = "public/uploads/#{name}"
    File.open(path, "wb") { |file| file.write tmpfile.read}
    Api::Result.new(true, {url: path})
  rescue JWT::DecodeError
    401
  end
end
