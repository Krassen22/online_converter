require 'convertor_api/convert_api.rb'

class RequestsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:update_status]
	skip_before_action :authenticate_user!, only: [:update_status]
	
	def index
		@request = Request.new
	end

	def create
		@request = Request.new request_params
		if current_user.has_requests?
			create_request
		else
			set_error_messages "Request limit reached"
		end
	end

	def update_status
		if params["queue-answer"]
			request_status_update
		end
		redirect_to root_path
	end

	private
	## update status
	
	def request_status_update
		response = parse_xml params["queue-answer"]
		request = Request.match_hash response[:hash_key]
		request.update status: set_status_message(response)
	end

	def set_status_message response
		response[:converted] ? "Converted" : "Error"
	end

	def parse_xml xml_file
		Convert::ConvertApi.get_request_values xml_file
	end

	## other

	def create_request
		response = make_request
		if response[:success]
			set_values response
			save_request
		else
			set_error_messages response[:message]
		end
	end

	def save_request
		if @request.save
			redirect_to root_path, notice: "New request was made" 
		else
			set_error_messages
		end
	end

	def request_params
		params.require(:request).permit(:media_type, :convert_to, :source_url)
	end
	
	def set_values response
		@request.hash_key = response[:hash_key]
		@request.download_link = response[:directDownload]
		@request.user = current_user
	end

	def set_error_messages error = nil
		flash[:notice] ||= error || @request.errors.full_messages.join("<br />")
		render 'index'
	end

	def make_request
		convert = Convert::ConvertApi.new
		convert.send_request request_params 
	end
end
