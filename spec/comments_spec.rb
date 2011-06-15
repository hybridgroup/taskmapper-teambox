require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Teambox::Comment" do
  before(:all) do
    headers = {'Authorization' => 'Basic MDAwMDAwOg==', 'Accept' => 'application/json'}
    headers_post = {'Authorization' => 'Basic MDAwMDAwOg==', 'Content-Type' => 'application/json'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v2/projects/test_project.json', headers, fixture_for('projects/12345'), 200
      mock.get '/api/v2/projects/test_project/tasks.json', headers, fixture_for('tasks'), 200
      mock.get '/api/v2/projects/test_project/tasks/42.json', headers, fixture_for('tasks/42'), 200
      mock.get '/api/v2/projects/test_project/tasks/42/comments.json', headers, fixture_for('comments'), 200
      mock.post '/api/v2/projects/test_project/tasks/42/comments.json', headers_post, fixture_for('comments/create'), 200
    end
    @project_id = '12345'
    @task_id = 42
  end
  
  before(:each) do
    @ticketmaster = TicketMaster.new(:teambox, {:name => 'anymoto', :login => '000000'})
    @project = @ticketmaster.project(@project_id)
    @ticket = @project.ticket(@task_id)
    @ticket.project_id = @project.project_id
    @klass = TicketMaster::Provider::Teambox::Comment
  end
  
  it "should be able to load all comments" do
    @comments = @ticket.comments
    @comments.should be_an_instance_of(Array)
    @comments.first.should be_an_instance_of(@klass)
  end
  
  it "should return the class" do
    @ticket.comment.should == @klass
  end
  
  it "should be able to create a comment" do
    @comment = @ticket.comment!(:content => 'New comment created.')
    @comment.should be_an_instance_of(@klass)
  end
end
