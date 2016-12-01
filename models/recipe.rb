class Recipe < ActiveRecord::Base

  has_many :favors
  has_many :users_favor, :through => :favors, :source => :user

  belongs_to :user

  has_many :ingredients

  has_many :steps


  def to_json_obj fields = nil
    obj = {}
    default = ["id", "name", "user_id", "create_time", "picture"]
    fields ||= default
    fields.each do |key|
      obj.store(key, instance_eval("self.#{key}")) if default.include? key
    end
    obj
  end

end