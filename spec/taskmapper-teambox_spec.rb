require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

  describe "TaskMapper::Provider::Teambox" do

  before (:all) do
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

    @taskmapper = TaskMapper.new(:teambox, {:username => "anymoto",
                                                :password => "000000", 
                                                :client_id => 'abcdef000000', 
                                                :client_secret => 'ghijk11111'})
  end
  
  it "should be able to instantiate a new instance" do
    @taskmapper.should be_an_instance_of(TaskMapper)
    @taskmapper.should be_a_kind_of(TaskMapper::Provider::Teambox)
  end

  it "should return true for a valid authentication" do 
    @taskmapper.valid?.should be_true
  end
  
  
end
