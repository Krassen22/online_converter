module RequestsHelper

	def show_converters
		"".tap do |links|
			Converter.all.each { |converter| links.concat link_to(converter, request_path(converter.name), class: "data-converter-type-navigation") }
		end.html_safe
	end

	def set_action request
		if request.converted?
			"<td><a href='#{ file_download_path(request.download_file) }'>Download</a></td>
			<td>#{ link_to 'Delete', request_path(request), method: :delete, data: { confirm: 'Are you certain you want to delete this?' } }</td>".html_safe
		elsif request.error?
			"<td colspan='2'>#{ link_to 'Retry', request_path(request.format.converter.name) }</td>".html_safe
		end
	end

end
