# Load the rails application

require File.expand_path('../application', __FILE__)
require "ruby-debug"  
require 'cached_model'
require 'MemCache'

$CLASSPATH << "/Applications/Cache/dev/java/lib/JDK15/CacheDB.jar"

# Initialize the rails application
Sweetapp::Application.initialize!

# Init memcached
memcache_options = {
  :c_threshold => 10_000,
  :compression => true,
  :debug => true,
  :namespace => 'Sweetapp',
  :readonly => false,
  :urlencode => false
}

CACHE = MemCache.new memcache_options
CACHE.servers = 'localhost:11211'

