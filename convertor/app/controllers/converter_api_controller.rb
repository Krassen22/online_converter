require 'digest/sha1'

class ConverterApiController < ApplicationController
	before_action :set_user, except: [:login]

	skip_before_action :verify_authenticity_token
	skip_before_action :authenticate_user!

	def login
		token = get_user_token
		render plain: token
	end

	def get_requests
		render json: @current_user.requests.as_json(only: [:download_file])
	end

	private 
	
	def get_user_token
		user = User.find_by email: params[:email]
		if user && user.valid_password?(params[:password])
			set_session user
		else
			"Error"
		end
	end

	def set_session user
		token = generate_token
		session = ConverterApi.new token: token, user: user
		session.save ? token : "Error"
	end
	
	def generate_token
		Digest::SHA1.hexdigest params[:email] + ConverterApi.count.to_s
	end

	def set_user
		token = ConverterApi.find_by(token: token_params)
		if token
			@current_user = token.user
		else 
			render plain: "Error"
		end
	end

	def token_params
		params.require(:token)
	end	
	
end
