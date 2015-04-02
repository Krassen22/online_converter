module ApplicationHelper
	def nav_link link_text, link_path, method: :get
		"<li>#{ link_to link_text, link_path, method: method }</li>".html_safe
	end

	def get_user
		user, level = user_signed_in? ? [current_user.email, current_user.level] : ["Guest", "none"]
		"Welcome <span>#{ user }</span> | Level: <span>#{ level }</span>".html_safe
	end
end
