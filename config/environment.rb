# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Attendance::Application.initialize!

#Paperclip.options[:command_path] = "D:\Program Files\ImageMagick-6.7.5-Q16"
Attendance::Application.config.session_store :cookie_store, {
  :key =>           '_session_id',
  :secret=>         'helloallen'
}