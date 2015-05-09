class LevelsController < ApplicationController

	def index
		@levels = Level.all
	end

	def upgrade
		change_user_level if params[:level]
		redirect_to :back
	end

	def change_user_level
		current_user.update level: get_level
	end

	def get_level
		Level.find params[:level]
	end

end
