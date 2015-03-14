require 'securerandom'
require 'net/http'

module Convert
	class Convert
		def self.convert args = {}
			file, output = self.get_file_names args[:convert_to]
			input = args[:source_url]
			Process.fork do 
				system "ffmpeg -i #{ input } #{ output } -y"
			end
			file
		end

		private 

		def self.get_file_names format
			path = "lib/convertor/converted_files/"
			file_name = SecureRandom.urlsafe_base64(20).to_s + "." + format
			return file_name, path + file_name
		end
			
		def self.remove_file path
			`rm #{ path }`
		end	
	end
end
