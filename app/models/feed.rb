require "open-uri"
require "timeout"
require "simple-rss"
require "ri_cal"

class Feed < ActiveRecord::Base
  TTL = 30.minutes
  TTL_ON_ERROR = 10.minutes
  TIMEOUT = 10 # In seconds
  CONTENT_TYPES = {
    "application/rss+xml" => lambda { |content| SimpleRSS.parse(content) },
    "text/calendar" => lambda { |content| RiCal.parse_string(content) }
  }.with_indifferent_access
  DEFAULT_CONTENT_TYPE = "application/rss+xml"
  
  delegate :entries, :items, :to => :parsed_contents
  
  def self.content_types
    self::CONTENT_TYPES
  end
  
  def self.supported_content_types
    self.content_types.keys
  end
  
  def self.default_content_type
    self::DEFAULT_CONTENT_TYPE
  end
  
  def content_type
    read_attribute(:content_type) || self.class::DEFAULT_CONTENT_TYPE
  end
  
  def parsed_contents
    @parsed_contents ||= parse_content
  end
  
  def contents(force_reload = false)
    if force_reload || expires_at.nil? || expires_at < Time.now.utc
      begin
        self.expires_at = Time.now.utc + TTL
        new_contents = remote_contents
        parse_content(new_contents) # Check that we can actually parse it
        write_attribute(:contents, new_contents)
        save
      rescue StandardError, Timeout::Error, SimpleRSSError => exception
        logger.error("Loading feed #{url} failed with #{exception.inspect}")
        self.expires_at = Time.now.utc + TTL_ON_ERROR
        save
      end
    else
      logger.info("Loading feed from cache: #{url}")
    end
    
    read_attribute(:contents)
  end
  
  def remote_contents
    logger.info("Loading feed from remote: #{url}")
    Timeout.timeout(TIMEOUT) { open(url).read }
  end

  private
    def parse_content(content = nil)
      parser = self.class.content_types[self.content_type]
      raise ArgumentError.new("Invalid ContentType for #{self.class.name}##{self.id}") unless parser
      content ||= self.contents
      parser.call(content)
    end
end
