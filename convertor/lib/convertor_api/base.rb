require 'net/http'
require 'yaml'

module Convert
	module Base
		def get_config
			content = File.read "#{ Rails.root }/config/convert_api_config.yml"
			YAML.load content
		end

		def make_request content, url
			uri = URI(url)
			Net::HTTP.post_form(uri, 'queue' => content).body	
		end
	end
end
