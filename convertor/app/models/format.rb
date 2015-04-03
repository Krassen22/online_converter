class Format < ActiveRecord::Base
	belongs_to :converter

	validates :format, presence: true, allow_blank: false
	validates :converter_id, presence: true, allow_blank: false
end
