# Load the rails application

require File.expand_path('../application', __FILE__)
require "ruby-debug"  

$CLASSPATH << "/Applications/Cache/dev/java/lib/JDK15/CacheDB.jar"

# Initialize the rails application
Sweetapp::Application.initialize!
