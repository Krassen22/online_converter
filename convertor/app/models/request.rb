class Request < ActiveRecord::Base
	validates :source_url, length: { minimum: 5 }	
	
	belongs_to :user

	scope :newest, -> { where("created_at > ?", Time.now-1.day) }

	def converted?
		status == "Converted"
	end

end
