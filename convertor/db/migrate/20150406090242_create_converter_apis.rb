class CreateConverterApis < ActiveRecord::Migration
  def change
    create_table :converter_apis do |t|

			t.integer :user_id
			t.string 	:token

      t.timestamps null: false
    end
  end
end
