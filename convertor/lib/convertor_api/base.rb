require 'net/http'

module Convert
	class Base
		def make_request content
			uri = URI(@url)
			Net::HTTP.post_form(uri, 'queue' => content).body	
		end
	end
end
