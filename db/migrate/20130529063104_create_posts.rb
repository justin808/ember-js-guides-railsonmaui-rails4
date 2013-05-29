class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :author
      t.date :published_at
      t.text :intro
      t.text :extended

      t.timestamps
    end
  end
end
