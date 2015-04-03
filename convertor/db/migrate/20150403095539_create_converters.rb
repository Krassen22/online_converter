class CreateConverters < ActiveRecord::Migration
  def change
    create_table :converters do |t|
			t.string :name
      t.timestamps null: false
    end
  end
end
