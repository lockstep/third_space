class AddLikedColumnToSolutionLike < ActiveRecord::Migration[5.0]
  def change
    add_column :solution_likes, :liked, :boolean, default: true
  end
end
