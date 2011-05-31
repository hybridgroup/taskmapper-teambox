require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Teambox::Ticket" do
  before(:all) do
    headers = {'Authorization' => 'Basic OjAwMDAwMA==', 'Accept' => 'application/json'}
    headers_post_put = {'Authorization' => 'Basic OjAwMDAwMA==', 'Content-Type' => 'application/json'}
    @project_id = '12345'
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v2/projects.json', headers, fixture_for('projects'), 200
      mock.get '/api/v2/projects/test_project.json', headers, fixture_for('projects/test_project'), 200
      mock.get '/api/v2/projects/test_project/cards/42.json', headers, fixture_for('tickets/42'), 200
      mock.get '/api/v2/projects/test_project/cards.json', headers, fixture_for('tickets'), 200
      mock.get '/api/v2/projects/test_project/cards/42.json', headers, fixture_for('tickets/42'), 200
      mock.put '/api/v2/projects/test_project/cards/42.json', headers_post_put, '', 200
      mock.post '/api/v2/projects/test_project/cards.json', headers_post_put, '', 200
    end
  end

  before(:each) do 
    @ticketmaster = TicketMaster.new(:teambox, {:username => 'anymoto', :password => '000000'})
    @project = @ticketmaster.project(@project_id)
    @klass = TicketMaster::Provider::Teambox::Ticket
  end

  it "should be able to load all tickets" do 
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on an array of id's" do
    @tickets = @project.tickets([42])
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.name.should == 'Ticket 1'
  end

  it "should be able to load all tickets based on attributes" do
    @tickets = @project.tickets(:project_id => 42)
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.name.should == 'Ticket 1'
  end

  it "should return the ticket class" do
    @project.ticket.should == @klass
  end

  it "should be able to load a single ticket" do
    @ticket = @project.ticket(42)
    @ticket.should be_an_instance_of(@klass)
    @ticket.name.should == 'Ticket 1'
  end

  it "shoule be able to load a single ticket based on attributes" do
    @ticket = @project.ticket(:project_id => 42)
    @ticket.should be_an_instance_of(@klass)
    @ticket.name.should == 'Ticket 1'
  end

  it "should be able to update and save a ticket" do 
    @ticket = @project.ticket(42)
    @ticket.description = 'New ticket description'
    @ticket.save.should == true
  end

  it "should be able to create a ticket" do 
    @ticket = @project.ticket!(:title => 'Ticket #12', :description => 'Body')
    @ticket.should be_an_instance_of(@klass)
  end

end
