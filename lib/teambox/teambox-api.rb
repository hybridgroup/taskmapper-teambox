require 'rubygems'
require 'active_support'
require 'active_resource'

# Ruby lib for working with the Teambox API's JSON interface.
# You should set the authentication using your login
# credentials with HTTP Basic Authentication.

# This library is a small wrapper around the REST interface

module TeamboxAPI
  class Error < StandardError; end
  class << self

    #Sets up basic authentication credentials for all the resources.
    def authenticate(username, password)
      @username  = username
      @password  = password
      self::Base.user = username
      self::Base.password = password
    end 

    def resources
      @resources ||= []
    end
  end

  class Base < ActiveResource::Base
    self.site = 'https://teambox.com/api/1/'
    self.format = :json
    def self.inherited(base)
      TeamboxAPI.resources << base
      super
    end
  end

  # Find projects
  #
  #   MingleAPI::Project.find(:all) # find all projects for the current account.
  #   MingleAPI::Project.find('my_project')   # find individual project by ID
  #
  # Creating a Project
  #
  #   project = MingleAPI::Project.new(:name => 'Ninja Whammy Jammy')
  #   project.save
  #   # => true
  #
  #
  # Updating a Project
  #
  #   project = MingleAPI::Project.find('my_project')
  #   project.name = "A new name"
  #   project.save
  #
  # Finding tickets
  # 
  #   project = MingleAPI::Project.find('my_project')
  #   project.tickets
  #


  class Project < Base
    def self.instantiate_collection(collection, prefix_options = {})
      objects = collection["objects"]
      objects.collect! { |record| instantiate_record(record, prefix_options) }
    end
  end

  # Find tickets
  #
  #  MingleAPI::Ticket.find(:all, :params => { :identifier => 'my_project' })
  #
  #  project = UnfuddleAPI::Project.find('my_project')
  #  project.tickets
  #  project.tickets(:name => 'a new name')
  #


  class Task < Base
    self.site += '/projects/:project_id/task_list/:task_list_id/'
  end

  class Comment < Base
   self.site += '/projects/:project_id/tasks/:task_id/'
  end

end
