class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
			t.string :respond_url		
			t.integer :user_id
      t.timestamps null: false
    end
  end
end
