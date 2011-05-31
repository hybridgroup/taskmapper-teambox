module TicketMaster::Provider
  module Teambox
    # Ticket class for ticketmaster-teambox
    API = TeamboxAPI::Task # The class to access the api's tickets
    
    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here
      
      def initialize(*object)
        if object.first
          args = object
          object = args.shift
          project_id = args.shift
          @system_data = {:client => object}
          unless object.is_a? Hash
           hash = {:status => object.status,
                   :name => object.name,
                   :task_id => object.id,
                   :task_list_id => object.task_list_id,
                   :updated_at => object.updated_at,
                   :user_id => object.user_id,
                   :project_id => object.project_id,
                   :comments_count => object.comments_count}
          else
            hash = object
          end
          super hash
        end
      end
      
      
    end
  end
end
