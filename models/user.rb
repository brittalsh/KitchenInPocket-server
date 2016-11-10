class User < ActiveRecord::Base
  has_many :recipes
  
  has_many :follows, :class_name => 'Follow', :foreign_key => :follower_id
  has_many :followings, :through => :follows, :source => :followed

  has_many :be_followeds, :class_name => 'Follow', :foreign_key => :followed_id
  has_many :followers, :through => :be_followeds, :source => :follower

  has_many :home_lines, :through => :followings, :source => :recipes

  has_many :favors
  has_many :favored_recipes, :through => :favors, :source => :recipe

end