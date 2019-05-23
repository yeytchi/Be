class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.references :season, foreign_key: true
    end
  end
end
