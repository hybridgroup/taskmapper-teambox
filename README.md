# taskmapper-teambox

This is a provider for [taskmapper](http://ticketrb.com). It provides interoperability with [Teambox](http://www.teambox.com).

# Usage and Examples

First we have to instantiate a new taskmapper instance:

    teambox = TaskMapper.new(:teambox, {:username => "foo", :password => "bar", :client_id => "your_client_id", :client_secret => "your_client_secret"})

If you do not pass in username, password, client id and client secret you won't get any information.

== Finding Projects

You can find your own projects by doing:

    projects = teambox.projects # Will return all your projects
    projects = teambox.projects([12345, 67890]) # You must use your projects identifier 
    project = teambox.project(12345) # Also use project identifier in here
	
== Finding Tickets

    tickets = project.tickets # All open issues
    ticket = project.ticket(<ticket_number>)

== Open Tickets
    
	ticket = project.ticket!({:name => "New ticket", :task_list_id => 23232})

= Update a ticket
	
	ticket.name = "New ticket name"
	ticket.save

== Finding Comments
  
  comments = ticket.comments #All comments

== Create Comments

  comment = ticket.comment!(:body => "this is a new comment")

## Requirements

* rubygems (obviously)
* taskmapper gem (latest version preferred)
* jeweler gem and bundler gem (only if you want to repackage and develop)
* OAuth2 gem

The taskmapper gem and OAuth2 gem should automatically be installed during the installation of these gems if it is not already installed.

## Other Notes

Since this and the taskmapper gem is still primarily a work-in-progress, minor changes may be incompatible with previous versions. Please be careful about using and updating this gem in production.

If you see or find any issues, feel free to open up an issue report.


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 [Hybrid Group](http://hybridgroup.com). See LICENSE for details.
