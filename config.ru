# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Sweetapp::Application
at_exit { ActiveRecord::Base.clear_all_connections! }
