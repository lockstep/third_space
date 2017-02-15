class DropTableInputs < ActiveRecord::Migration[5.0]
  def up
    drop_table :inputs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
