class Recipe < ActiveRecord::Base

  has_many :favors
  has_many :users_favor, :through => :favors, :source => :user

  belongs_to :user

  has_many :ingredients

  has_many :steps

end