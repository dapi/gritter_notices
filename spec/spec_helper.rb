# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV["RAILS_ENV"] ||= 'test'

require 'rails/all'
require 'active_record'
require 'action_view'
require 'action_controller'

require 'rspec'
require 'rspec/rails'
require 'shoulda'

require 'gritter_notices'

# require 'nulldb_rspec'
# include NullDB::RSpec::NullifiedDatabase

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  # :database=>'/tmp/gritter_notices.sqlite3'
  :database => ":memory:"
)
#ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))

require 'lib/generators/templates/migration'
CreateGritterNoticesTable.migrate :up

require 'spec/support/migration'
CreateUsersTable.migrate :up

require 'spec/support/user'

require 'app/models/gritter_notice'

require 'factory_girl'
require 'spec/support/factories'

# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include GritterNotices::RSpecMatcher
end
