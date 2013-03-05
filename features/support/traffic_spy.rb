module TrafficSpy
  extend self

  def configure(url)
    @url = url
  end

  def connection
    @connection ||= Faraday.new url: @url
  end
end
