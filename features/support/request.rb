class Request

  def self.generator
    @generator ||= WeightedGenerator.new
  end

  def self.define(request,weight)
    generator.define(request,weight)
  end

  #   payload = {
  #   "url":"http://jumpstartlab.com/blog",
  #   "requestedAt":"2013-02-16 21:38:28 -0700",
  #   "respondedIn":37,
  #   "referredBy":"http://jumpstartlab.com",
  #   "requestType":"GET",
  #   "parameters":[],
  #   "eventName": "socialLogin",
  #   "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
  #   "resolutionWidth":"1920",
  #   "resolutionHeight":"1280",
  #   "ip":"63.29.38.211"
  # }
  def self.generate
    request = generator.generate

    payload = { payload: generate_payload(request).to_json }

    TrafficSpy.connection.post "sources/#{request[:source]}/data", payload
  end

  def self.generate_payload(request)
    params = {}

    params[:url] = request[:url]
    params[:respondedIn] = rand(request[:response_time])
    params[:respondedAt] = random_time_within_the_last_day
    params[:eventName] = request[:event]
    params[:requestType] = request[:verb]
    params[:parameters] = []
    params[:userAgent] = UserAgent.generate

    resolution = Resolution.generate
    params[:resolutionWidth] = resolution[:width]
    params[:resolutionHeight] = resolution[:height]
    params[:ip] = "127.0.0.1"
    params[:referredBy] = generator.generate[:url]

    params
  end

  def self.random_time_within_the_last_day
    Time.now - rand(86400)
  end
end
