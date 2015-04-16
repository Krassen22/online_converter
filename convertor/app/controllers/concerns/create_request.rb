module CreateRequest
	require 'convertor/convertor.rb'

	extend ActiveSupport::Concern

	def make_new_request
		@request = Request.new request_params
		if current_user.has_requests?
			create_request
		else
			set_error_messages "Request limit reached"
		end
	end

	def create_request
		file = convert
		set_values file
		save_request
	end

	def set_values file
		@request.download_file = file
		@request.user = current_user
	end

	def save_request
		unless @request.save
			set_error_messages
		end
	end

	def convert 
		Convert::Convert.convert request_params
	end

	def request_params
		params.require(:request).permit(:convert_to, :source_url)
	end

end
