module LevelsHelper
	def upgrade_button level
		level != current_user.level ? link_to("Upgrade", level_upgrade_path(level), method: :post) : "Current"
	end	
end
