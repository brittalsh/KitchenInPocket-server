require 'sinatra'
require 'active_record'
require 'jwt'
require './config/environments'

require './models/favor'
require './models/follow'
require './models/ingredient'
require './models/recipe'
require './models/step'
require './models/user'

require './lib/errors'
require './lib/result'
require './lib/userutil'

require 'byebug'

include Error
include Api
include UserUtil

get '/' do
  redirect "test.html"
end

post '/api/v1/users/login' do
  byebug
  @json = JSON.parse request.body.read
  username = @json["username"]
  password = @json["password"]
  begin
    token = UserUtil::authenticate username, password
    byebug
    Api::Result.new(true, {access_token: token}).to_json
  rescue Error::AuthError => e
    Api::Result.new(false, e.message).to_json
  end
end

#no authentication
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