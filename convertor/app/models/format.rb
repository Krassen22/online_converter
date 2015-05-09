class Format < ActiveRecord::Base
	belongs_to :converter
	has_many :requests

	def to_s
		format
	end

	validates :format, :converter_id, presence: true, allow_blank: false
end
