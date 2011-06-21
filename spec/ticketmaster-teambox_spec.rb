require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Teambox" do
  
  it "should be able to instantiate a new instance" do
    
    #stubs = Faraday::Adapter::Test::Stubs.new do |stub|
    #  ACCESS_TOKEN = { "access_token" => "01234567890abcdef", "username" => "anymoto" } 
    #  stub.post('/oauth/token') { [200, {}, ACCESS_TOKEN.to_json] }
    #end

    #new_method = Faraday::Connection.method(:new)
    #Faraday::Connection.stub(:new) do |*args|
    #  connection = new_method.call(*args) do |builder|
    #    builder.adapter :test, stubs
    #  end
    #end
    
    @ticketmaster = TicketMaster.new(:teambox, {:username => "anymoto",
                                                :password => "000000", 
                                                :client_id => 'abcdef000000', 
                                                :client_secret => 'ghijk11111'})
    @ticketmaster.should be_an_instance_of(TicketMaster)
    @ticketmaster.should be_a_kind_of(TicketMaster::Provider::Teambox)
  end
  
end
