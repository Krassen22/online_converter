require 'convertor/convertor.rb'

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

	def download
		send_file "lib/convertor/converted_files/" + params[:hash]
	end

	private

	def create_request
		file = convert
		set_values file
		save_request
	end

	def set_values file
		@request.download_file = file
		@request.user = current_user
		@request.status = "Converted" # remove
	end

	def convert 
		Convert::Convert.convert params[:request]
	end

	def save_request
		if @request.save
			redirect_to root_path, notice: "New request was made" 
		else
			set_error_messages
		end
	end

	def request_params
		params.require(:request).permit(:convert_to, :source_url)
	end
	
	def set_error_messages error = nil
		flash[:notice] = error || @request.errors.full_messages.join("<br />")
		render 'index'
	end

end
