require 'convertor_api/convert_api.rb'

class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
		# must be fixed
		1.upto(1).each do |index|
			request = get_user_request index
			respond = make_request request
			if respond[:converted]
				request.update status: "Converted"
			end
		end
	end

	private 

	def get_user_request index
		@user.requests[-index]
	end

	def make_request request
		convert = Convert::ConvertApi.new 'd5f199db46752c458c9f2597ccd8e609'
		convert.get_request request.hash_key
	end
end
