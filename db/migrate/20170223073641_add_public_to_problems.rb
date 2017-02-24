class AddPublicToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :public, :boolean, default: false
  end
end
