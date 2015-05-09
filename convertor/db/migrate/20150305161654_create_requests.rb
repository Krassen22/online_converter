class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
			t.string :source_url		
			t.integer :user_id
			t.integer :format_id
			t.string :status, default: "Converting.."
			t.string :download_file
      t.timestamps null: false
    end
  end
end
