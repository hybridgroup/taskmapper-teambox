require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskMapper::Provider::Teambox::Project" do
  before(:each) do
   @headers_get = {'Authorization' => 'OAuth ', 'Accept' => 'application/json'}  
   @headers = {'Authorization' => 'OAuth ', 'Content-Type' => 'application/json'} 
   ActiveResource::HttpMock.respond_to do |mock|
   end
  end
  let(:project_id) { 23216 }
  let(:taskmapper) { TaskMapper.new(:teambox, :username => "anymoto", :password => "000000", :client_id => 'abcdef000000', :client_secret => 'ghijk11111') }
  let(:project_class) { TaskMapper::Provider::Teambox::Project }

  describe "Retrieving projects" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/1/projects.json?count=0', @headers_get, fixture_for('projects'), 200
      end
    end

    context "when calling #projects to an instance of taskmapper" do 
      subject{ taskmapper.projects } 
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of project_class }
    end
  end

  it "should be able to load all projects" do 
    pending
    @taskmapper.projects.should be_an_instance_of(Array)
    @taskmapper.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load projects from an array of id's" do 
    pending
    @projects = @taskmapper.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == @project_id
  end

  it "should be able to load all projects from attributes" do 
    pending
    @projects = @taskmapper.projects(:id => 23216)
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == 23216
  end

  it "should be able to find a project" do 
    pending
    @taskmapper.project.should == @klass
    @taskmapper.project.find(@project_id).should be_an_instance_of(@klass)
  end

  it "should be able to find a project by identifier" do 
    pending
    @taskmapper.project(@project_id).should be_an_instance_of(@klass)
    @taskmapper.project(@project_id).id.should == @project_id
  end

  it "should be able to create a new project" do 
    pending
    @project = @taskmapper.project!(:name => 'New Project', :organization_id => '56789', :permalink => 'new-project').should be_an_instance_of(@klass)
  end

  it "should be able to update and save a project" do
    pending
    @project = @taskmapper.project(@project_id)
    @project.update!(:name => 'some new name').should == true
  end
end
