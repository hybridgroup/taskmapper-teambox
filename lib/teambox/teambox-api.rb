require 'rubygems'
require 'active_support'
require 'active_resource'
require 'oauth2'

# Ruby lib for working with the Teambox API's JSON interface.
# You should set the authentication using your login
# credentials, client_id and client_secret (OAuth2).

# This library is a small wrapper around the REST interface

module TeamboxAPI
  class Error < StandardError; end
  class << self
    attr_accessor :client_id, :client_secret, :site, :username, :password, :token
    def authenticate(client_id, client_secret, username, password)
      @username  = username
      @password  = password
      @site = 'https://teambox.com/'
      @client_id = client_id
      @client_secret = client_secret

      self::Base.user = username
      self::Base.password = password
      self.token = access_token(self)

    end

    def access_token(master)
      @auth_url = '/oauth/token'
      consumer = OAuth2::Client.new(master.client_id,
                                    master.client_secret,
                                    {:site => 
                                              {:url => master.site, 
                                               :ssl => {:verify => OpenSSL::SSL::VERIFY_NONE,
                                                        :ca_file => nil
                                                       }
                                              },
                                    :authorize_url => @auth_url,
                                    :parse_json => true})
                                      
      response = consumer.request(:post, @auth_url, {:grant_type => 'password', 
                                                    :client_id => master.client_id,
                                                    :client_secret => master.client_secret,
                                                    :username => master.username, 
                                                    :password => master.password,
                                                    :scope => 'read_projects write_projects'})

      OAuth2::AccessToken.new(consumer, response['access_token']).token
    
    end

    def token=(value)
      resources.each do |klass|
        klass.headers['Authorization'] = 'OAuth ' + value.to_s
      end
      @token = value
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

    def self.collection_path(organization_path, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{organization_path}#{collection_name}.#{format.extension}#{query_string(query_options)}"
    end
    
    def collection_path(options = nil)
        organization_path = "organizations/#{attributes[:organization_id].to_s}/"
        self.class.collection_path(organization_path, options || prefix_options)
    end

    def self.instantiate_collection(collection, prefix_options = {})
      objects = collection["objects"]
      objects.collect! { |record| instantiate_record(record, prefix_options) }
    end

    def tickets(options = {})
      Task.find(:all, :params => options.update(:project_id => project_id))
    end

    def project_id
      self[:id]
    end

    def encode(options={})
      val = []
      attributes.each_pair do |key, value|
        val << "#{URI.escape key}=#{URI.escape value}" rescue nil
      end
      val.join('&')
    end

    def update
       connection.put(element_path(prefix_options) + '?' + encode, nil, self.class.headers).tap do |response|
          load_attributes_from_response(response)
       end
    end

    def create
      connection.post(collection_path + '?' + encode, nil, self.class.headers).tap do |response|
        self.id = id_from_response(response)
        load_attributes_from_response(response)
      end
    end

    def organization_id
      attributes[:organization_id]
    end

    
    def self.find_every(options)
          #add :count => 0 in order to retrieve objects with no limits. Default is 20 objects per request.
          options.merge!(:params => {:count => 0})
          begin
            case from = options[:from]
            when Symbol
              self.instantiate_collection(get(from, options[:params]))
            when String
              path = "#{from}#{query_string(options[:params])}"
              self.instantiate_collection(connection.get(path, headers) || [])
            else
              prefix_options, query_options = split_options(options[:params])
              path = self.collection_path(nil, prefix_options, query_options)
              self.instantiate_collection( (connection.get(path, headers) || []), prefix_options )
            end
          rescue ActiveResource::ResourceNotFound
            # Swallowing ResourceNotFound exceptions and return nil - as per
            # ActiveRecord.
            nil
          end
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

    self.site += 'projects/:project_id/'

    def self.collection_path(task_list_path, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{task_list_path}#{collection_name}.#{format.extension}#{query_string(query_options)}"
    end

    def collection_path(options = nil)
        task_list_path = "task_lists/#{attributes[:task_list_id]}/"
        self.class.collection_path(task_list_path, options || prefix_options)
    end

    def self.instantiate_collection(collection, prefix_options = {})
        objects = collection["objects"]
        objects.collect! { |record| instantiate_record(record, prefix_options) }
    end

    def encode(options={})
      val = []
      attributes.each_pair do |key, value|
        val << "#{URI.escape key}=#{URI.escape value}" rescue nil
      end
      val.join('&')
    end

    def update
       connection.put(element_path(prefix_options) + '?' + encode, nil, self.class.headers).tap do |response|
          load_attributes_from_response(response)
       end
    end
   
    def create
      connection.post(collection_path + '?' + encode, nil, self.class.headers).tap do |response|
        self.id = id_from_response(response)
        load_attributes_from_response(response)
      end
    end

    def self.find_every(options)
          #add :count => 0 in order to retrieve objects with no limits. Default is 20 objects per request.
          options[:params].merge!(:count => 0)
          begin
            case from = options[:from]
            when Symbol
              self.instantiate_collection(get(from, options[:params]))
            when String
              path = "#{from}#{query_string(options[:params])}"
              self.instantiate_collection(connection.get(path, headers) || [])
            else
              prefix_options, query_options = split_options(options[:params])
              path = self.collection_path(nil, prefix_options, query_options)
              self.instantiate_collection( (connection.get(path, headers) || []), prefix_options )
            end
          rescue ActiveResource::ResourceNotFound
            # Swallowing ResourceNotFound exceptions and return nil - as per
            # ActiveRecord.
            nil
          end
    end

  end

  class Comment < Base
    self.site += 'projects/:project_id/tasks/:task_id/'

    def self.instantiate_collection(collection, prefix_options = {})
        objects = collection["objects"]
        objects.collect! { |record| instantiate_record(record, prefix_options) }
    end

    def create
      connection.post(collection_path + '?' + encode, nil, self.class.headers).tap do |response|
        load_attributes_from_response(response)
      end
    end

    def encode(options={})
      val=[]
      attributes.each_pair do |key, value|
        val << "#{URI.escape key}=#{URI.escape value}" rescue nil
      end
      val.join('&')
    end

  end

end
