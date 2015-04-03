class Request < ActiveRecord::Base
	validates :source_url, length: { minimum: 5 }	
	validates :convert_to, presence: true, allow_blank: false
	
	belongs_to :user

	scope :newest, -> { where("created_at > ?", Time.now-1.day) }

	def converted?
		status == "Converted"
	end

	def self.match_hash hash_key
		where("hash_key = ?", hash_key).first
	end

end
