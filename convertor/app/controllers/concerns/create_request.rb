module CreateRequest
	require 'convertor/convertor.rb'

	extend ActiveSupport::Concern

	def make_new_request
		@request = Request.new request_params
		set_error_messages "File too large" and return unless valid_file? get_file_path
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
		set_error_messages unless @request.save
	end

	def valid_file? file
		file.size < current_user.level.max_bytes.bytes
	end

	def convert 
		Convert::Convert.convert convert_params
	end

	def get_file_path
		params[:request][:source_url]
	end

	def request_params
		params.require(:request).permit(:format_id, :source_url)
	end

	def convert_params
		request_params.merge({ convert_to: @request.format.to_s })
	end

end
