class Notify < ApplicationMailer
	default from: "kalo150@abv.bg"

	def convert_ready request 
		@request = request
		mail to: @request.user.email, subject: "Convert ready"
	end
	
end

