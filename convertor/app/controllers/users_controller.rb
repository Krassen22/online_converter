class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show_requests
		@user = current_user
	end

	def clear_errors
		Request.clear_errors current_user
		redirect_to :back
	end
end
