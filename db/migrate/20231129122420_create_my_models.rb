class CreateMyModels < ActiveRecord::Migration[7.1]
  def change
    create_table :my_models do |t|
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
