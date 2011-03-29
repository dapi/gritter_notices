$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'active_record'
require 'action_view'
# require 'nulldb_rspec'
# include NullDB::RSpec::NullifiedDatabase


require 'gritter_notices'

require 'app/models/gritter_notice'

require 'factory_girl'


#   Factory.definition_file_paths = [
#   File.join(Rails.root, 'spec', 'factories')
# ]


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end
