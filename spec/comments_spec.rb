require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskMapper::Provider::Teambox::Comment" do
  before(:each) do
    headers_get = {'Authorization' => 'OAuth ', 'Accept' => 'application/json'}  
    headers = {'Authorization' => 'OAuth ', 'Content-Type' => 'application/json'} 
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/1/projects/23216.json', headers_get, fixture_for('projects/23216'), 200
      mock.get '/api/1/projects/23216/tasks.json?count=0', headers_get, fixture_for('tasks'), 200
      mock.get '/api/1/projects/23216/tasks/85915.json', headers_get, fixture_for('tasks/85915'), 200
      mock.get '/api/1/projects/23216/tasks/85915/comments.json?count=0', headers_get, fixture_for('comments'), 200
      mock.post '/api/1/projects/23216/tasks/85915/comments.json?body=New%20comment%20created.', headers, fixture_for('comments/create'), 200
    end
    @project_id = 23216
    @task_id = 85915

    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      ACCESS_TOKEN = { "access_token" => "01234567890abcdef", "username" => "anymoto" } 
      stub.post('/oauth/token') { [200, {}, ACCESS_TOKEN.to_json] }
    end

    new_method = Faraday::Connection.method(:new)
    Faraday::Connection.stub(:new) do |*args|
      connection = new_method.call(*args) do |builder|
        builder.adapter :test, stubs
      end
    end

    @taskmapper = TaskMapper.new(:teambox, {:username => "anymoto",
                                     :password => "000000", 
                                     :client_id => 'abcdef000000', 
                                     :client_secret => 'ghijk11111'})
    @klass = TaskMapper::Provider::Teambox::Comment
    @project = @taskmapper.project(@project_id)
    @ticket = @project.ticket(@task_id)
    @ticket.project_id = @project.id
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
    @comment = @ticket.comment!(:body => 'New comment created.')
    @comment.should be_an_instance_of(@klass)
  end
end
