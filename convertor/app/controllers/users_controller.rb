class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show_requests
		@user = current_user
	end
end
