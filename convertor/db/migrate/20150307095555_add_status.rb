class AddStatus < ActiveRecord::Migration
  def change
		add_column :requests, :status, :string, default: "Converting.."
  end
end
