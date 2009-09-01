class FeedPortlet < Portlet
  # handler "erb"
  
  def render
    raise ArgumentError, "No feed URL specified" if self.url.blank?
    @feed = Feed.find_or_create_by_url_and_content_type(self.url, self.content_type).parsed_contents
    instance_eval(self.code) unless self.code.blank?
  end
end
