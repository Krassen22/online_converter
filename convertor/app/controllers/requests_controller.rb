require 'convertor_api/convert_api.rb'

class RequestsController < ApplicationController
	def index
		@request = Request.new
	end

	def create
		@request = Request.new(request_params)
		@request.user = current_user
		convert = Convert::ConvertApi.new 'd5f199db46752c458c9f2597ccd8e609'
		response = convert.send_request request_params 
		if response[:code].to_i == success
			save_request
		else
			flash[:notice] = response[:message]
			render 'index'
		end
	end

	private
	
	def save_request
		if @request.save
			flash[:notice] = "New request was made"
			redirect_to root_path
		else
			flash[:notice] = @request.errors.full_messages.join "<br />"
			render 'index'
		end
	end

	def request_params
		params.require(:request).permit(:media_type, :convert_to, :source_url)
	end
	
	def success
		0
	end
end
