require File.dirname(__FILE__) + "/../test_helper"

class CalendarFeedTest < ActiveSupport::TestCase
  def setup
    @feed = Feed.create!(:url => "http://example.com/events.ics", :content_type => "text/calendar")
    @contents = "BEGIN:VEVENT\nDTSTART;VALUE=DATE:20090903\nDTEND;VALUE=DATE:20090904\nDTSTAMP:20090831T192355Z\nDESCRIPTION:\nLOCATION:\nSEQUENCE:0\nSUMMARY:Example\nEND:VEVENT"
  end
  
  test "parsed_contents should return the contents parsed by RiCal" do
    @feed.stubs(:contents).returns(@contents)
    RiCal.stubs(:parse_string).with(@contents).returns(parsed_contents = stub)
    
    assert_equal parsed_contents, @feed.parsed_contents
  end
  
  test "default content_type should be used when no other is specified" do
    assert_equal Feed.default_content_type, Feed.new.content_type
  end
  
  test "parse_content should raise an error when content_type is not valid" do
    assert_raise(ArgumentError) { Feed.new(:content_type => "invalid").parsed_contents }
  end
end
