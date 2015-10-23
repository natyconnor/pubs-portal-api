class RequestAttachment < ActiveRecord::Base
	belongs_to :publication_request

	has_attached_file :file, styles: lambda { |a| a.instance.check_file_type },
		:url => "/:class/:attachment/:id/:style_:basename.:extension"

	validates_attachment_presence :file
	validates_attachment_content_type :file, content_type: [/\Aimage\/.*\Z/, 'application/x-rar-compressed', 'application/zip', 'application/pdf']
	validates_attachment_file_name :file, matches: [/png\Z/, /jpe?g\Z/, /gif\Z/, /zip\Z/, /rar\Z/, /psd\Z/, /pdf\Z/]

	private
		def check_file_type
			if is_image_type?
				{ large: "500x500>", medium: "300x300>", small: "100x100>", thumb: "50x50#" }
			else
				{}
			end
		end

		def is_image_type?
			content_type = /\Aimage\/.*\Z/
		end

end
