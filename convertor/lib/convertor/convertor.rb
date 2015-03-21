require 'securerandom'
require 'net/http'
require 'convertor/ffmpeg'

module Convert
	class Convert
		class << self

			def convert args = {}
				file, output = get_file_names args[:convert_to]
				input = args[:source_url]
				FFmpeg.convert input, output
				file
			end

			private 

			def get_file_names format
				path = FFmpeg.get_dir
				file_name = make_name format
				return file_name, path + file_name
			end
			
			def make_name format
				SecureRandom.urlsafe_base64(20).to_s + "." + format
			end

			def remove_file path
				`rm #{ path }`
			end	

		end
	end
end
