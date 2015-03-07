require 'convertor_api/base'
require 'nokogiri'

module Convert
	class SendConvertApi < Base

		def initialize api_key
			@url = 'http://www13.online-convert.com/queue-insert'
			@api_key = api_key
		end

		def send_request type, convert_to, source
			request = format_send_request type, convert_to, source
			response = make_request request
			get_values response
		end

		private

		def get_values response
			xml_response = Nokogiri::XML(response)
			{
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
					<notificationUrl>91.211.189.161</notificationUrl>
				</queue>"
		end

	end
end
