class ChangeCommentColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :comments, :comment, :description
  end
end
