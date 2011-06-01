require 'rubygems'
require 'active_support'
require 'active_resource'
require 'net/https'

# Ruby lib for working with the Teambox API's JSON interface.
# You should set the authentication using your login
# credentials with HTTP Basic Authentication.

# This library is a small wrapper around the REST interface

module TeamboxAPI
  class Error < StandardError; end
  class << self
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
    self.site = 'https://teambox.com/api/1'
    self.format = :json
    def self.inherited(base)
      TeamboxAPI.resources << base
      super
    end
  end

  # Find projects
  #
  #   TeamboxAPI::Project.find(:all) # find all projects for the current account.
  #   TeamboxAPI::Project.find(12345)   # find individual project by ID
  #
  # Creating a Project
  #
  #   project = TeamboxAPI::Project.new(:name => 'Ninja Whammy Jammy')
  #   project.save
  #   # => true
  #
  #
  # Updating a Project
  #
  #   project = TeamboxAPI::Project.find(12345)
  #   project.name = "A new name"
  #   project.save
  #
  # Finding tickets
  # 
  #   project = TeamboxAPI::Project.find(12345)
  #   project.tickets
  #


  class Project < Base
    def self.instantiate_collection(collection, prefix_options = {})
      objects = collection["objects"]
      objects.collect! { |record| instantiate_record(record, prefix_options) }
    end

    def encode(options={})
      val = []
      attributes.each_pair do |key, value|
       val << "project[#{URI.escape key}]=#{URI.escape value}" rescue nil
      end
      val.join('&')
    end

    #def update
    #   connection.put(element_path(prefix_options) + '?' + encode, nil, self.class.headers).tap do |response|
    #      puts element_path(prefix_options) + '?' + encode
    #      load_attributes_from_response(response)
    #   end
    #end

    def create
      connection.post(collection_path + '?' + encode, nil, self.class.headers).tap do |response|
        self.id = id_from_response(response)
        load_attributes_from_response(response)
      end
    end

    def tickets(options = {})
      Task.find(:all, :params => options.update(:id => id))
    end
    

    def id
      @attributes['id']
    end

  end

  # Find tickets
  #
  #  TeamboxAPI::Task.find(:all, :params => { :name => 'my_project' })
  #
  #  project = TeamboxAPI::Project.find('my_project')
  #  project.tickets
  #  project.tickets(:name => 'a new name')
  #


  class Task < Base

    def self.instantiate_collection(collection, prefix_options = {})
        objects = collection["objects"]
        objects.collect! { |record| instantiate_record(record, prefix_options) }
    end
  end

  class Comment < Base
   self.site += '/projects/:id/tasks/:task_id/'
  end

end
