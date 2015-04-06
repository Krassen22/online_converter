class Format < ActiveRecord::Base
	belongs_to :converter

	validates :format, :converter_id, presence: true, allow_blank: false
end
