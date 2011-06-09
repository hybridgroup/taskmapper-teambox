module TicketMaster::Provider
  # This is the Teambox Provider for ticketmaster
  module Teambox
    include TicketMaster::Provider::Base
    TICKET_API = TeamboxAPI::Task # The class to access the api's tickets
    PROJECT_API = TeamboxAPI::Project # The class to access the api's projects
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Teambox.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:teambox, auth)
    end
    
    # Providers must define an authorize method. This is used to initialize and set authentication
    # parameters to access the API
    def authorize(auth = {})
      @authentication ||= TicketMaster::Authenticator.new(auth)
      auth = @authentication
      if auth.username.blank? and auth.password.blank? and auth.client_id.nil? and auth.client_secret.nil?
        raise "Please provide username, password, client id and client secret"
      end
      TeamboxAPI.authenticate(auth.client_id, auth.client_secret, auth.username, auth.password)
      #if auth.username.blank? and auth.password.blank?
      #  raise "Please provide username and password"
      #end
      #TeamboxAPI.authenticate(auth.username, auth.password)
    end
    
    # declare needed overloaded methods here
    
  end
end


