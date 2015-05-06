require 'digest/sha1'

class ConverterApiController < ApplicationController

	include CreateRequest

	before_action :check_token, except: [:login, :register]

	skip_before_action :verify_authenticity_token
	skip_before_action :authenticate_user!

	def login
		token = get_user_token
		render plain: token
	end

	def register
		user = User.new user_params

		if user.save && params[:confirm_password] == params[:password]
			render plain: "Success"
		else	
			render plain: "Error"
		end
	end

	def get_requests
		requests = current_user.requests.where("id > ?", params[:id])
		render json: requests.as_json(only: [:id, :status, :source_url, :download_file])
	end

	def make_request
		make_new_request
		render plain: "Success" unless performed?
	end

	private 
	
	def get_user_token
		user = User.find_by email: params[:email]
		if user && user.valid_password?(params[:password])
			set_session user
		else
			set_error_messages "Error"
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

	def current_user
		current_user ||= set_user
	end

	def set_user
		token = ConverterApi.find_by(token: token_params)
		token.user
	end

	def check_token
		set_error_messages "Error" if ConverterApi.find_by(token: token_params).nil?
	end

	def token_params
		params.require(:token)
	end	

	def user_params
		params.permit(:email, :password)	
	end

	def set_error_messages error = nil
		error_message = error || @request.errors.full_messages.join("|")
		render plain: error_message
	end
	
end
