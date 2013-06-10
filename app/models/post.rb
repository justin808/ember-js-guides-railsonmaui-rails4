class Post < ActiveRecord::Base
  validates_presence_of :published_at, :author
end
