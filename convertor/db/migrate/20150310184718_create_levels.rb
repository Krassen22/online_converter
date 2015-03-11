class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|

			t.string :name, null: false
			t.decimal :cost
			t.integer :max_requests, null: false

      t.timestamps null: false
    end
  end
end
