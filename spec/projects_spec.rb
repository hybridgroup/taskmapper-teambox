require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskMapper::Provider::Teambox::Project" do
  before(:each) do
   headers_get = {'Authorization' => 'OAuth ', 'Accept' => 'application/json'}  
   headers = {'Authorization' => 'OAuth ', 'Content-Type' => 'application/json'} 
   @project_id = 23216
   ActiveResource::HttpMock.respond_to do |mock|
     mock.get '/api/1/projects.json?count=0', headers_get, fixture_for('projects'), 200
     mock.get '/api/1/projects/23216.json', headers_get, fixture_for('projects/23216'), 200
     mock.post '/api/1/organizations/56789/projects.json?name=New%20Project&permalink=new-project&organization_id=56789', headers, '', 201
     mock.put '/api/1/projects/23216.json?name=some%20new%20name&permalink=teambox-api-example-project&created_at=2010-07-30%2020:16:55%20+0000&updated_at=2010-08-28%2014:20:35%20+0000', headers, '', 200
   end

    @taskmapper = TaskMapper.new(:teambox, {:username => "anymoto",
                                                :password => "000000", 
                                                :client_id => 'abcdef000000', 
                                                :client_secret => 'ghijk11111'})
    @klass = TaskMapper::Provider::Teambox::Project
  end

  it "should be able to load all projects" do 
    @taskmapper.projects.should be_an_instance_of(Array)
    @taskmapper.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load projects from an array of id's" do 
    @projects = @taskmapper.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == @project_id
  end

  it "should be able to load all projects from attributes" do 
    @projects = @taskmapper.projects(:id => 23216)
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == 23216
  end

  it "should be able to find a project" do 
    @taskmapper.project.should == @klass
    @taskmapper.project.find(@project_id).should be_an_instance_of(@klass)
  end

  it "should be able to find a project by identifier" do 
    @taskmapper.project(@project_id).should be_an_instance_of(@klass)
    @taskmapper.project(@project_id).id.should == @project_id
  end

  it "should be able to create a new project" do 
    @project = @taskmapper.project!(:name => 'New Project', :organization_id => '56789', :permalink => 'new-project').should be_an_instance_of(@klass)
  end

  it "should be able to update and save a project" do
    @project = @taskmapper.project(@project_id)
    @project.update!(:name => 'some new name').should == true
  end
  


end
