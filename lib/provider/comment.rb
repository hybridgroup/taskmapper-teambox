module TicketMaster::Provider
  module Teambox
    # The comment class for ticketmaster-teambox
    #
    # Do any mapping between Ticketmaster and your system's comment model here
    # versions of the ticket.
    #
    class Comment < TicketMaster::Provider::Base::Comment
      API = TeamboxAPI::Comment # The class to access the api's comments
      # declare needed overloaded methods here
      
      def self.find_by_id(project_id, ticket_id, id)
        self.search(project_id, ticket_id).select { |ticket| ticket.id == id }.first
      end

      def self.find_by_attributes(project_id, ticket_id, attributes = {})
        search_by_attribute(self.search(project_id, ticket_id), attributes)
      end

      def self.search(project_id, ticket_id, options = {}, limit = 1000)
        comments = API.find(:all, :params => {:project_id => project_id, :task_id => ticket_id}).collect { |comment| self.new comment }
      end

      def updated_at
        @updated_at ||= begin
          Time.parse(self[:updated_at])
        rescue
          self[:updated_at]
        end
      end
      
      def created_at
        @updated_at ||= begin
          Time.parse(self[:created_at])
        rescue
          self[:created_at]
        end
      end

      
    end
  end
end
