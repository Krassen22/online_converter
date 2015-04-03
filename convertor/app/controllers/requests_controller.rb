require 'convertor/convertor.rb'

class RequestsController < ApplicationController

	skip_before_action :verify_authenticity_token, only: [:convert_ready, :download]
	skip_before_action :authenticate_user!, only: [:convert_ready, :download]

	def index
		@request = Request.new
	end

	def create
		@request = Request.new request_params
		@converters = Converter.all
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
		update_status_and_notify
		redirect_to root_url
	end	

	def destroy
		@request = Request.find params[:id]
		if @request.user == current_user
			destroy_request
			flash[:notice] = "Successfully deleted"
		else	
			flash[:alert] = "You can't delete this"
		end
		redirect_to :back
	end

	private

	def update_status_and_notify
		@request = Request.find_by(download_file: params[:file_name])
		@request.update status: params[:new_status]

		Notify.convert_ready(@request).deliver_now
	end

	def destroy_request
		Convert::Convert.remove_file @request.download_file
		@request.destroy
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
		flash[:alert] = error || @request.errors.full_messages.join("<br />")
		render 'index'
	end

end
