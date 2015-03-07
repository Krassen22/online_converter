class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
			t.string :source_url		
			t.integer :user_id
			t.string :media_type
			t.string :convert_to
			t.string :hash_key
      t.timestamps null: false
    end
  end
end
