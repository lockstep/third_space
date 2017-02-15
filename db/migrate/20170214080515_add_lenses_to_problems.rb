class AddLensesToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :adaptability, :string
    add_column :problems, :cultural_competence, :string
    add_column :problems, :empathy, :string
    add_column :problems, :intellectual_curiosity, :string
    add_column :problems, :thinking, :string
  end
end
