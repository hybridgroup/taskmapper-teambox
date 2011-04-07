require 'rubygems'
require 'active_support'
require 'active_resource'
require 'oauth2'
require 'net/https'

# Ruby lib for working with the Teambox API's JSON interface.
# You should set the authentication using your login
# credentials with HTTP Basic Authentication.

# This library is a small wrapper around the REST interface

module TeamboxAPI
  class Error < StandardError; end
  class << self
     attr_accessor :client_id, :client_secret, :site, :username, :password, :token
     attr_reader :account

    #Sets up basic authentication credentials for all the resources.
    def authenticate(username, password, client_id, client_secret)
      @username  = username
      @password  = password
      @client_id = client_id
      @client_secret = client_secret
      @site = 'https://teambox.com'

      self::Base.user = username
      self::Base.password = password

      self.token = access_token(self)

    end

    def account=(name)
      resources.each do |klass|
        klass.site = klass.site_format % (host_format % [protocol, domain_format, name])
      end
      @account = name
    end

    def access_token(master)
      @auth_url = '/oauth/authorize'
      consumer ||= OAuth2::Client.new(master.client_id,
                                   master.client_secret,
                                   {:site =>
                                     {:url => master.site+'/oauth/token',
                                      :ssl => {:verify => OpenSSL::SSL::VERIFY_NONE,
                                               :ca_file => nil
                                              }
                                     },
                                    :authorize_url => @auth_url,
                                    :parse_json => true})
      response = consumer.request(:post, @auth_url, {:grant_type => 'authorization_code',
                                                   :client_id => master.client_id,
                                                   :client_secret => master.client_secret,
                                                   :username => master.username,
                                                   :password => master.password,
                                                   :redirect_uri => ''},
                                                   'Content-Type' => 'application/x-www-form-urlencoded')
      OAuth2::AccessToken.new(consumer, response['access_token']).token
    end

    def token=(value)
      resources.each do |klass|
        klass.headers['Authorization'] = 'OAuth' + value.to_s
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

    def encode(options={})
      val = []
      attributes.each_pair do |key, value|
       val << "#{URI.escape key}=#{URI.escape value}" rescue nil
      end
      val.join('&')
    end

    #def update
     #  connection.put(element_path(prefix_options) + '?' + encode, nil, self.class.headers).tap do |response|
      #    load_attributes_from_response(response)
      # end
    #end

    def create
      connection.post(collection_path + '?' + encode, nil, self.class.headers).tap do |response|
        self.id = id_from_response(response)
        load_attributes_from_response(response)
      end
    end

    def id
      @attributes['id']
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
    self.site += '/projects/:id/task_list/:task_list_id/'
  end

  class Comment < Base
   self.site += '/projects/:id/tasks/:task_id/'
  end

end
