class RequestsController < ApplicationController

	include CreateRequest

	skip_before_action :verify_authenticity_token, only: [:convert_ready, :download]
	skip_before_action :authenticate_user!, only: [:convert_ready, :download]

	def show
		@text_value = get_default_url
		@converter = get_converter
		@request = Request.new
	end

	def create
		set_upload_file
		make_new_request unless performed?
		delete_uploaded_file
		redirect_to root_path, notice: "New request was made" unless performed?
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

	def delete_uploaded_file
		`rm -f #{ get_uploaded_file }`
	end

	def get_default_url
		params[:request_default_url]
	end

	def set_upload_file
		params[:request][:source_url] = get_uploaded_file.path if get_uploaded_file
	end

	def get_converter
		params[:id].nil? ? Converter.first : Converter.find_by(name: params[:id])
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

	def get_uploaded_file
		params[:request][:file]
	end

	def set_error_messages error = nil
		flash[:alert] = error || @request.errors.full_messages.join("<br />")
		redirect_to action: 'show', id: params[:id]
	end

end
