# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bcms_feeds}
  s.version = "1.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jon Leighton"]
  s.date = %q{2009-09-01}
  s.description = %q{A BrowserCMS module which fetches, caches and displays RSS/Atom feeds -- now with iCalendar support!}
  s.email = %q{j@jonathanleighton.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "app/models/feed.rb",
     "app/portlets/feed_portlet.rb",
     "app/views/portlets/feed/_form.html.erb",
     "app/views/portlets/feed/render.html.erb",
     "db/migrate/20090813213104_add_feeds.rb",
     "lib/bcms_feeds.rb",
     "rails/init.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jonleighton/bcms_feeds}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Feeds in BrowserCMS}
  s.test_files = [
    "test/unit/feed_test.rb",
     "test/unit/calendar_feed_test.rb",
     "test/unit/portlets/feed_portlet_test.rb",
     "test/test_helper.rb",
     "test/performance/browsing_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<simple-rss>, [">= 0"])
      s.add_runtime_dependency(%q<ri_cal>, [">= 0"])
    else
      s.add_dependency(%q<simple-rss>, [">= 0"])
      s.add_dependency(%q<ri_cal>, [">= 0"])
    end
  else
    s.add_dependency(%q<simple-rss>, [">= 0"])
    s.add_dependency(%q<ri_cal>, [">= 0"])
  end
end
