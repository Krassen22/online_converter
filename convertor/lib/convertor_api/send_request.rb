require 'nokogiri'

module Convert
	module SendConvertApi

		def send_convert_query_url
			'http://www13.online-convert.com/queue-insert'
		end

		def send_request args = {}
			request = format_send_request args[:media_type], args[:convert_to], args[:source_url]
			response = make_request request, send_convert_query_url
			send_request_values response
		end

		def send_request_values response
			xml_response = Nokogiri::XML(response)
			{
				success:  xml_response.xpath("//status//code").text.to_i == 0 ? true : false,
				code: xml_response.xpath("//status//code").text,
				message: xml_response.xpath("//status//message").text,
				hash_key: xml_response.xpath("//params//hash").text,
				directDownload: "http://www13.online-convert.com/download-file/#{ xml_response.xpath("//params//hash").text }"
			}
		end

		def format_send_request type, convert_to, source
			 "<?xml version='1.0' encoding='utf-8' ?>
				<queue><apiKey>#{ @api_key }</apiKey>
				<targetType>#{ type }</targetType>
					<targetMethod>convert-to-#{ convert_to }</targetMethod>
					<testMode>true</testMode>
					<sourceUrl>#{ source }</sourceUrl>
					<notificationUrl>url</notificationUrl>
				</queue>"
		end

	end
end
