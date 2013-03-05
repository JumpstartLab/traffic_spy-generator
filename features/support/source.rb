class Source
  attr_reader :name, :root_url

  def initialize(name,root_url)
    @name = name
    @root_url = root_url
  end

  def create
    TrafficSpy.connection.post 'sources', { identifier: name, rootUrl: root_url }
  end

  def create_campaign(campaign_name,events)
    TrafficSpy.connection.post "sources/#{name}/campaigns", { events: events }
  end
end
