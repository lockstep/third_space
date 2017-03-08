class AddLikesCountToProblem < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :likes_count, :integer, default: 0
  end
end
