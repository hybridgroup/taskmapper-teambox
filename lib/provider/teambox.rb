module TaskMapper::Provider
  # This is the Teambox Provider for taskmapper
  module Teambox
    include TaskMapper::Provider::Base
    TICKET_API = TeamboxAPI::Task # The class to access the api's tickets
    PROJECT_API = TeamboxAPI::Project # The class to access the api's projects
    
    # This is for cases when you want to instantiate using TaskMapper::Provider::Teambox.new(auth)
    def self.new(auth = {})
      TaskMapper.new(:teambox, auth)
    end
    
    # Providers must define an authorize method. This is used to initialize and set authentication
    # parameters to access the API
    def authorize(auth = {})
      @authentication ||= TaskMapper::Authenticator.new(auth)
      auth = @authentication
      if auth.username.blank? and auth.password.blank? and auth.client_id.nil? and auth.client_secret.nil?
        raise "Please provide username, password, client id and client secret"
      end
      TeamboxAPI.authenticate(auth.client_id, auth.client_secret, auth.username, auth.password)
    end
    
    # declare needed overloaded methods here
    #
    def valid?
      begin
        PROJECT_API.find(:first)
        true
      rescue
        false
      end
    end
    
  end
end


