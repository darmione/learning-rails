class Post
  attr_accessor :name, :description, :tags
  def initialize(name, description, tags = [])
    @name = name
    @description = description
    @tags = tags
  end
end
