class User < ActiveRecord::Base
  has_many :recipes
  
  has_many :follows, :class_name => 'Follow', :foreign_key => :follower_id
  has_many :followings, :through => :follows, :source => :followed

  has_many :be_followeds, :class_name => 'Follow', :foreign_key => :followed_id
  has_many :followers, :through => :be_followeds, :source => :follower

  has_many :home_lines, :through => :followings, :source => :recipes

  has_many :favors
  has_many :favored_recipes, :through => :favors, :source => :recipe

  validates :name, presence: {message: "Please provide your user name."}, uniqueness: {message: "User name already exists."}, length: {in: 5..20, message: "User name length: 5 ~ 20"}
  validates :password, presence: {message: "Please provide your password."}, length: {in: 5..20, message: "Password length: 5 ~ 20"}

  def to_json_obj fields = nil
    obj = {}
    default = ["id", "name", "create_time", "intro"]
    fields ||= default
    fields.each do |key|
      obj.store(key, instance_eval("self.#{key}")) if default.include? key
    end
    obj
  end

end