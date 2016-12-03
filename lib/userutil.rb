module UserUtil

  class UserList
    # ActiveRecord::Relation
    attr_accessor :users_relation

    def initialize users
      @users_relation = users
    end

    def to_json_obj fields = nil
      list = [];
      @users_relation.each do |user_record|
        list.push(user_record.to_json_obj fields)
      end
      list
    end
  end

  # Authenticate the username and password 
  # If match, return access_token
  def authenticate username, password
    user = User.find_by name: username
    if user == nil
      raise Error::AuthError, "User not found."
    elsif password != user.password
      raise Error::AuthError, "Password is not correct."
    else
      user
    end
  end

  # check whether the token is valid and not expired yet.
  def check_token token 
    decoded_token = JWT.decode token, $TOKEN_SECRET, true, { algorithm: $TOKEN_HASH }
    User.find(decoded_token[0]["user_id"])
  end

  # generate access_token by Hashing algorithm
  def generate_token user
    expire_time = Time.now.to_i + 4 * 3600
    token_data = {user_id: user.id, exp: expire_time}
    JWT.encode token_data, $TOKEN_SECRET, $TOKEN_HASH
  end

  # sign up new user
  def create_new_user userinfo
    if (userinfo["password"] != userinfo["password2"])
      raise Error::SignUpError, "Your two password inputs are different. Please type again."
    end
    user = User.new
    user.name = userinfo["username"]
    user.password = userinfo["password"]
    user.create_time = Time.now().to_i
    raise Error::SignUpError, user.errors.messages.values[0][0] unless user.save
    user
  end

  # find a user by id
  def find_user_by_id user_id
    user = User.find user_id
  end

  # change user password
  def change_password user, old_password, new_password, new_password2
    raise Error::ChangePasswdError, "Password authentication failed." if user.password != old_password
    raise Error::ChangePasswdError, "Your two password input are different. Please type again." if new_password != new_password2
    user.password = new_password
    raise Error::ChangePasswdError, user.errors.messages.values[0][0] unless user.save
  end

  # return a list of json objects
  def get_following_user_list user_id
    users = UserList.new User.find(user_id).followings
    users.to_json_obj
  end

  # return a list of json objects
  def get_follower_user_list user_id
    users = UserList.new User.find(user_id).followers
    users.to_json_obj
  end

  def add_follow_relation user_id, following_id
    follow = Follow.new
    follow.follower_id = user_id
    follow.followed_id = following_id
    raise Error::FollowError, follow.errors.messages.values[0][0] unless follow.save
  end

  def delete_follow_relation user_id, following_id
    follow = Follow.find_by(follower_id: user_id, followed_id: following_id)
    raise Error::FollowError, "no such relationship" if follow == nil
    follow.destroy
  end
end