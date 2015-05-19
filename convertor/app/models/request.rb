class Request < ActiveRecord::Base
	validates :source_url, length: { minimum: 5 }	
	validates :format_id, presence: true, allow_blank: false
	
	belongs_to :format

	belongs_to :user

	scope :newest, -> { where("created_at > ?", Time.now-1.day) }

	def converted?
		status == "Converted"
	end

	def error?
		status == "Error"
	end

	def self.clear_errors user
		destroy_all status: "Error", user_id: user
	end

	def self.match_hash hash_key
		where("hash_key = ?", hash_key).first
	end

end
