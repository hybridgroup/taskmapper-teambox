$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'spec'
require 'ticketmaster'
require 'ticketmaster-teambox'

def fixture_for(name)
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + '.json')
end
