require 'convertor/convertor.rb'

class RequestsController < ApplicationController

	skip_before_action :verify_authenticity_token, only: [:convert_ready, :download]
	skip_before_action :authenticate_user!, only: [:convert_ready, :download]

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

	def convert_ready
		request = Request.find_by(download_file: params[:file_name])
		request.update status: params[:new_status]
		redirect_to root_url
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
