require 'convertor_api/base'
require 'nokogiri'

module Convert
	class GetConvertApi < Base

		def initialize api_key
			@url = 'http://api.online-convert.com/queue-status'
			@api_key = api_key
		end

		def get_request hash_key
			request = format_get_request hash_key
			response = make_request request
			self.class.get_values(response)
		end

		def self.get_values response
			xml_response = Nokogiri::XML(response)
			{
				converted: xml_response.xpath("//status//code").text.to_i == 100 ? true : false
			}
		end

		private
	
		def format_get_request hash_key
			"<?xml version='1.0' encoding='utf-8' ?>
			<queue>
				<apiKey>#{ @api_key }</apiKey>
				<hash>#{ hash_key }</hash>
			</queue>"
		end

	end
end
