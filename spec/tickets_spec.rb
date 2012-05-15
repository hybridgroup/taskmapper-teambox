require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

VERBS = [:get, :post, :put, :delete]

describe "TaskMapper::Provider::Teambox::Ticket" do
  before(:each) do
   headers_get = {'Authorization' => 'OAuth ', 'Accept' => 'application/json'}  
   headers = {'Authorization' => 'OAuth ', 'Content-Type' => 'application/json'} 
   @project_id = 23216
   ActiveResource::HttpMock.respond_to do |mock|
     mock.get '/api/1/projects.json', headers_get, fixture_for('projects'), 200
     mock.get '/api/1/projects/23216.json', headers_get, fixture_for('projects/23216'), 200
     mock.get '/api/1/projects/23216/tasks/85915.json', headers_get, fixture_for('tasks/85915'), 200
     mock.get '/api/1/projects/23216/tasks.json?count=0', headers_get, fixture_for('tasks'), 200
     mock.get '/api/1/projects/23216/tasks/85915.json', headers_get, fixture_for('tasks/85915'), 200
     mock.put '/api/1/projects/23216/tasks/85915.json?name=New%20ticket%20name&updated_at=2010-08-29%2020:16:56%20+0000', headers, '', 200
     mock.post '/api/1/projects/23216/task_lists/30232/tasks.json?name=Mobile%20App', headers, '', 200
   end

    @taskmapper = TaskMapper.new(:teambox, {:username => "anymoto",
                                     :password => "000000", 
                                     :client_id => 'abcdef000000', 
                                     :client_secret => 'ghijk11111'})
    @project = @taskmapper.project(@project_id)
    @klass = TaskMapper::Provider::Teambox::Ticket
  end

  it "should be able to load all tickets" do 
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on an array of id's" do
    @tickets = @project.tickets([85915])
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.name.should == 'iPhone App'
  end

  it "should be able to load all tickets based on attributes" do
    @tickets = @project.tickets(:id => 85915)
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.name.should == 'iPhone App'
  end

  it "should return the ticket class" do
    @project.ticket.should == @klass
  end

  it "should be able to load a single ticket" do
    @ticket = @project.ticket(85915)
    @ticket.should be_an_instance_of(@klass)
    @ticket.name.should == 'iPhone App'
  end

  it "shoule be able to load a single ticket based on attributes" do
    @ticket = @project.ticket(:id => 85915)
    @ticket.should be_an_instance_of(@klass)
    @ticket.name.should == 'iPhone App'
  end

  it "should be able to update and save a ticket" do 
    @ticket = @project.ticket(85915)
    @ticket.name = 'New ticket name'
    @ticket.save.should == true
  end

  it "should be able to create a ticket" do 
    @ticket = @project.ticket!(:name => 'Mobile App', :task_list_id => 30232)
    @ticket.should be_an_instance_of(@klass)
  end

end
