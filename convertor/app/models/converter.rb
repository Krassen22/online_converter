class Converter < ActiveRecord::Base
	has_many :formats

	validates :name, presence: true, allow_blank: false

	def to_s
		name
	end
end
