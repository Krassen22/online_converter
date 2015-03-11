require 'net/http'
require 'yaml'

module Convert
	module Base
		def get_config
			content = File.read "lib/convertor_api/config/config.yml"
			YAML.load content
		end

		def make_request content, url
			uri = URI(url)
			Net::HTTP.post_form(uri, 'queue' => content).body	
		end
	end
end
