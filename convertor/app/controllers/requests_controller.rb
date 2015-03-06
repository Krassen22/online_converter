class RequestsController < ApplicationController
	def index
		@request = Request.new
	end

	def create
		@request = Request.new(request_params)
		@request.user = current_user
		if @request.save
			flash[:notice] = "New request was made"
			redirect_to root_path
		else
			render 'index'
		end
	end

	private
	
	def request_params
		params[:request].permit(:respond_url)
	end
end
