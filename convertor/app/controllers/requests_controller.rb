require 'convertor_api/convert_api.rb'

class RequestsController < ApplicationController
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

	private
	
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
