require 'convertor_api/convert_api.rb'

class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
		# must be fixed
		if @user.requests.count > 0
			1.upto(1).each do |index|
				request = get_user_request index
				respond = make_request request
				if respond[:converted]
					request.update status: "Converted"
				end
			end
		end
	end

	private 

	def get_user_request index
		@user.requests[-index]
	end

	def make_request request
		convert = Convert::ConvertApi.new
		convert.get_request request.hash_key
	end
end
