class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :published_at, :intro, :extended
end
