require 'net/http'
require 'yaml'

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
				params "files_path" 
			end

			private

			def params symbol
				@params ||= load_params
				@params[symbol] 
			end

			def load_params
				content = File.read("lib/convertor/config/config.yml")
				YAML.load content
			end

			def get_name file
				file_name = File.basename file
			end

			def file_status file
				File.exist?(file) ? params("on_success") : params("on_error")
			end	
		
			def make_request file_name
				uri = URI(params("notify_url") + file_name)
				Net::HTTP.post_form( uri, 'new_status' => file_status( get_dir + file_name) )
			end	
	
		end
	end
end
