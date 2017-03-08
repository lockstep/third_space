class ChangeCulturalCompetenceName < ActiveRecord::Migration[5.0]
  def change
    rename_column :problems, :cultural_competence, :cultural_competency
  end
end
