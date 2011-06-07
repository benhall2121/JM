# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Jm::Application.initialize! do |config|
	
	config.gem "authlogic"
	config.time_zone = 'UTC'
	config.action_controller.session_store = :active_record_store
	
end
