require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Teambox::Project" do
  before(:all) do
    headers = {'Authorization' => 'Basic OjAwMDAwMA==', 'Accept' => 'application/json'}
    headers_post = {'Authorization' => 'Basic OjAwMDAwMA==', 'Content-Type' => 'application/json'}
    @id = '12345'
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v2/projects.json', headers, fixture_for('projects'), 200
      mock.get '/api/v2/projects/test_project.json', headers, fixture_for('projects/test_project'), 200
      mock.get '/api/v2/projects/dumb.json', headers, fixture_for('projects/create'), 404
      mock.post '/api/v2/projects.json', headers_post, '', 200, 'Location' => '/projects/dumb'
    end
  end

  before(:each) do 
    @ticketmaster = TicketMaster.new(:teambox, {:username => 'anymoto', :password => '000000'})
    @klass = TicketMaster::Provider::Teambox::Project
  end

  it "should be able to load all projects" do 
    @ticketmaster.projects.should be_an_instance_of(Array)
    @ticketmaster.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load projects from an array of id's" do 
    @projects = @ticketmaster.projects([@identifier])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == @id
  end

  it "should be able to load all projects from attributes" do 
    @projects = @ticketmaster.projects(:id => 'test_project')
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == '12345'
  end

  it "should be able to find a project" do 
    @ticketmaster.project.should == @klass
    @ticketmaster.project.find(@id).should be_an_instance_of(@klass)
  end

  it "should be able to find a project by identifier" do 
    @ticketmaster.project(@id).should be_an_instance_of(@klass)
    @ticketmaster.project(@id).id.should == @id
  end

  it "should be able to create a new project" do 
    @project = @ticketmaster.project!(:name => 'Another project', :organization_id => '12345', :permalink => 'another-project').should be_an_instance_of(@klass)
  end


end
