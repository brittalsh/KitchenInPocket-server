module Error

  class AuthError < StandardError; end
  class SignUpError < StandardError; end
  class UserUpdateError < StandardError; end
  class ChangePasswdError < StandardError; end
  class FollowError < StandardError; end

end