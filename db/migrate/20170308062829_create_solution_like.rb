class CreateSolutionLike < ActiveRecord::Migration[5.0]
  def change
    create_table :solution_likes do |t|
      t.references :problem, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
