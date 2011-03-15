module TicketMaster::Provider
  module Teambox
    # Project class for ticketmaster-teambox
    #
    #
    class Project < TicketMaster::Provider::Base::Project
      API = TeamboxAPI::Project # The class to access the api's projects
      # declare needed overloaded methods here
      
      
      # copy from this.copy(that) copies that into this
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(:title => ticket.title, :description => ticket.description)
          ticket.comments.each do |comment|
            copy_ticket.comment!(:body => comment.body)
            sleep 1
          end
        end
      end

      def self.search(options = {}, limit = 1000)
        hash = API.find(:all)
        puts hash.inspect
        if hash.key?("objects")
          projects = hash["objects"].collect { |project| self.new project }
          search_by_attribute(projects, options, limit)
        end
      end

    end
  end
end


