module ApplicationHelper
	def nav_link link_text, link_path, method: :get
		link = link_to link_text, link_path, method: method
		(current_page?(link_path) ? "<li class='current_page_item'>#{ link }</li>" : "<li>#{ link }</li>").html_safe
	end

	def get_user
		user, level = user_signed_in? ? [current_user.email, current_user.level] : ["Guest", "none"]
		"Welcome <span>#{ user }</span> | Level: <span>#{ level }</span>".html_safe
	end

	def set_messages
		"".tap do |messages|
			messages.concat("<div class='alert-success'>#{ notice }</div>") if notice
			messages.concat("<div class='alert-danger'>#{ alert }</div>") if alert
		end.html_safe
	end
end
