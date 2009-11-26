ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'restful_json_rack'
require File.join(File.dirname(__FILE__), 'rails_app', 'config', 'environment')

require 'test_help'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :recipes do |t|
    t.string :name, :description
  end
end
