require 'net/http'

module Convert
	module Base
		def make_request content, url
			uri = URI(url)
			Net::HTTP.post_form(uri, 'queue' => content).body	
		end
	end
end
