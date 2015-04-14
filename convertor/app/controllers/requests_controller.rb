require 'convertor/convertor.rb'

class RequestsController < ApplicationController

	include CreateRequest

	skip_before_action :verify_authenticity_token, only: [:convert_ready, :download]
	skip_before_action :authenticate_user!, only: [:convert_ready, :download]

	def show
		@converter = get_converter
		@request = Request.new
	end

	def create
		make_new_request
		redirect_to root_path, notice: "New request was made" 
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

	def get_converter
		record = params[:id].to_i-1 || 0
		Converter.limit(1).offset(record).first
	end

	def update_status_and_notify
		@request = Request.find_by(download_file: params[:file_name])
		@request.update status: params[:new_status]

		Notify.convert_ready(@request).deliver_now
	end

	def destroy_request
		Convert::Convert.remove_file @request.download_file
		@request.destroy
	end

	def set_error_messages error = nil
		flash[:alert] = error || @request.errors.full_messages.join("<br />")
		redirect_to action: 'show', id: params[:id]
	end

end
