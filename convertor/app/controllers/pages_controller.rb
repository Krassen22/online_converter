class PagesController < ApplicationController

	skip_before_action :verify_authenticity_token
	skip_before_action :authenticate_user!

	def about
	end

	def contact
	end

	def home
	end

end
