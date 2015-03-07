class Request < ActiveRecord::Base
	validates :source_url, length: { minimum: 5 }	

	belongs_to :user
end
