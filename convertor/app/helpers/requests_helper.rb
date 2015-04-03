module RequestsHelper

	def show_converters
		"".tap do |links|
			Converter.all.each_with_index { |converter, index| links.concat link_to(converter, request_path(index+1)) }
		end.html_safe
	end
end
