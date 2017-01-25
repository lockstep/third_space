class CreateInputs < ActiveRecord::Migration[5.0]
  def change
    create_table :inputs do |t|
      t.references :problem, foreign_key: true
      t.string :lens
      t.string :input_type
      t.text :input_text

      t.timestamps
    end
  end
end
