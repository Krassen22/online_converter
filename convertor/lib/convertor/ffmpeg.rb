require 'net/http'

module Convert
	class FFmpeg 
		class << self

			def convert input, output
				Process.fork do
					system "ffmpeg -i #{ input } #{ output } -y"
					make_request(get_name output)
				end		
			end

			def get_dir
				"lib/convertor/converted_files/"
			end

			private

			def get_name file
				file_name = File.basename file
			end

			def file_status file
				File.exist?(file) ? "Converted" : "Error"
			end	
		
			def make_request file_name
				uri = URI('http://localhost:3000/convert_ready/' + file_name)
				Net::HTTP.post_form( uri, 'new_status' => file_status( get_dir + file_name) )
			end	
	
		end
	end
end
