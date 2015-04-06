class ConverterApi < ActiveRecord::Base
	belongs_to :user

	validates :user_id, :token, presence: true, allow_blank: false

	def self.clean_old_tokens
		self.old_tokens.destroy_all		
	end

	def self.old_tokens
		ConverterApi.where("created_at < ?", Time.now-1.minute)
	end
end
