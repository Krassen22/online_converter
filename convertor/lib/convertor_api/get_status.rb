require 'nokogiri'

module Convert
	module GetConvertApi
		
		def get_convert_query_url
			'http://api.online-convert.com/queue-status'
		end

		def get_request hash_key
			request = format_get_request hash_key
			response = make_request request, get_convert_query_url
			get_request_values response
		end

		def get_request_values response
			xml_response = Nokogiri::XML(response)
			{
				converted: xml_response.xpath("//status//code").text.to_i == 100 ? true : false
			}
		end

		def format_get_request hash_key
			"<?xml version='1.0' encoding='utf-8' ?>
			<queue>
				<apiKey>#{ @api_key }</apiKey>
				<hash>#{ hash_key }</hash>
			</queue>"
		end

	end
end
