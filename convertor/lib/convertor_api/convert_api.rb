require 'convertor_api/get_status'
require 'convertor_api/send_request'

module Convert
	class ConvertApi

		def initialize api_key
			@api_key = api_key
		end

		def send_request args = { media_type: nil, convert_to: nil, source_url: nil }
			send_api = SendConvertApi.new @api_key		
			send_api.send_request args[:media_type], args[:convert_to], args[:source_url]
		end

		def get_request hash
			get_api = GetConvertApi.new @api_key
			get_api.get_request hash
		end

		def self.parse_get_request response
			GetConvertApi.get_values response
		end
	end
end

#testing 
=begin

convert = Convert::ConvertApi.new 'd5f199db46752c458c9f2597ccd8e609'
puts convert.send_request 'video', 'mp4', 'https://www.sit.auckland.ac.nz/wiki/images/9/9f/Sample.flv' 
puts convert.get_request '6e5bdc3b792b25456e62a5b60f1efb9a'

=begin
# response

{:code=>"0", :message=>"Successfully inserted job into queue.", :hash=>"2aedbb39c7177bb53b7987a08b60a135", :directDownload=>"http://www13.online-convert.com/download-file/2aedbb39c7177bb53b7987a08b60a135"}
{:code=>"100", :hash=>"6e5bdc3b792b25456e62a5b60f1efb9a"}

=end
