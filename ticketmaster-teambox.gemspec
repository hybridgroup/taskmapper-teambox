# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ticketmaster-teambox}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Hybridgroup"]
  s.date = %q{2011-08-10}
  s.description = %q{Allows ticketmaster to interact with Teambox}
  s.email = %q{ana@hybridgroup.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/provider/comment.rb",
    "lib/provider/project.rb",
    "lib/provider/teambox.rb",
    "lib/provider/ticket.rb",
    "lib/teambox/teambox-api.rb",
    "lib/ticketmaster-teambox.rb",
    "spec/comments_spec.rb",
    "spec/fixtures/comments.json",
    "spec/fixtures/comments/create.json",
    "spec/fixtures/projects.json",
    "spec/fixtures/projects/23216.json",
    "spec/fixtures/projects/23217.json",
    "spec/fixtures/projects/create.json",
    "spec/fixtures/tasks.json",
    "spec/fixtures/tasks/85915.json",
    "spec/fixtures/tasks/85916.json",
    "spec/fixtures/tasks/create.json",
    "spec/projects_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/ticketmaster-teambox_spec.rb",
    "spec/tickets_spec.rb",
    "ticketmaster-teambox.gemspec"
  ]
  s.homepage = %q{http://ticketrb.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Ticketmaster Provider for Teambox}
  s.test_files = [
    "spec/comments_spec.rb",
    "spec/projects_spec.rb",
    "spec/spec_helper.rb",
    "spec/ticketmaster-teambox_spec.rb",
    "spec/tickets_spec.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ticketmaster>, ["= 0.6.6"])
      s.add_runtime_dependency(%q<oauth2>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 1.2.9"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.4"])
      s.add_runtime_dependency(%q<activeresource>, [">= 3.0.4"])
    else
      s.add_dependency(%q<ticketmaster>, ["= 0.6.6"])
      s.add_dependency(%q<oauth2>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 1.2.9"])
      s.add_dependency(%q<activesupport>, [">= 3.0.4"])
      s.add_dependency(%q<activeresource>, [">= 3.0.4"])
    end
  else
    s.add_dependency(%q<ticketmaster>, ["= 0.6.6"])
    s.add_dependency(%q<oauth2>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 1.2.9"])
    s.add_dependency(%q<activesupport>, [">= 3.0.4"])
    s.add_dependency(%q<activeresource>, [">= 3.0.4"])
  end
end

