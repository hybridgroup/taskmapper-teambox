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
      #
      def initialize(*object)
        if object.first
          object = object.first
          @system_data = {:client => object}
          unless object.is_a? Hash
            hash = {:body => object.body,
                    :user_id => object.user_id,
                    :target_id => object.target_id,
                    :created_at => object.created_at,
                    :updated_at => object.updated_at,
                    :id => object.id,
                    :project_id => object.prefix_options[:project_id]}
          else
            hash = object
          end
          super hash
        end
      end
      

      def self.find_by_id(project_id, task_id, id)
        self.search(project_id, task_id).select { |task| task.id == id }.first
      end

      def self.find_by_attributes(project_id, task_id, attributes = {})
        search_by_attribute(self.search(project_id, task_id), attributes)
      end

      def self.search(project_id, task_id, options = {}, limit = 1000)
        comments = API.find(:all, :params => {:project_id => project_id, :task_id => task_id, :count => 0}).collect { |comment| self.new comment }
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
