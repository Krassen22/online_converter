require 'convertor_api/get_status'
require 'convertor_api/send_request'
require 'convertor_api/base'


module Convert
	class ConvertApi
	
		include Base
		include GetConvertApi
		include SendConvertApi

		def initialize
			@params = get_config
		end

	end
end

#testing 
#=begin

#convert = Convert::ConvertApi.new
#puts convert.send_request 'video', 'mp4', 'https://www.sit.auckland.ac.nz/wiki/images/9/9f/Sample.flv' 
#puts convert.get_request '6e5bdc3b792b25456e62a5b60f1efb9a'

=begin
# response

{:code=>"0", :message=>"Successfully inserted job into queue.", :hash=>"2aedbb39c7177bb53b7987a08b60a135", :directDownload=>"http://www13.online-convert.com/download-file/2aedbb39c7177bb53b7987a08b60a135"}
{:code=>"100", :hash=>"6e5bdc3b792b25456e62a5b60f1efb9a"}

=end
