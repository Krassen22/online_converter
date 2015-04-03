class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
			t.string :format
			t.boolean :encoding, default: true
			t.boolean :decoding, default: true			
			t.integer :converter_id
      t.timestamps null: false
    end
  end
end
