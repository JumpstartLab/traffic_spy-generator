require 'json'

module TrafficSpy
  extend self

  def configure(url)
    @url = url
  end

  def connection
    @connection ||= Faraday.new url: @url
  end
end

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

class UserAgent
  def self.generator
    @generator ||= WeightedGenerator.new
  end

  def self.define(user_agent,weight)
    generator.define(user_agent,weight)
  end

  def self.generate
    generator.generate
  end
end

class Resolution
  def self.generator
    @generator ||= WeightedGenerator.new
  end

  def self.define(resolution,weight)
    generator.define(resolution,weight)
  end

  def self.generate
    generator.generate
  end
end

class WeightedGenerator
  def initialize
    @total_weight = 0
  end

  attr_reader :total_weight

  def resources
    @resources ||= {}
  end

  def define(resource,weight)
    start_weight = (total_weight > 0 ? total_weight + 1 : 0)
    @total_weight += weight

    range = (start_weight..total_weight)
    resources[range] = resource
  end

  def generate
    resources[weighted_key]
  end

  private

  def weighted_key
    result = rand(total_weight)
    key = resources.keys.find {|key| key.cover? result }
  end
end


Given(/^the user agents across all requests:$/) do |table|
  table.map_headers!("Weight" => :weight,"User Agents" => :user_agent)
  table.map_column!('Weight') {|weight| weight.to_i }

  table.hashes.each do |agents|
    UserAgent.define agents[:user_agent], agents[:weight]
  end
end

Given(/^the resolutions across all requests:$/) do |table|
  table.map_headers!("Weight" => :weight,"Resolutions" => :resolution)

  table.map_column!('Weight') {|weight| weight.to_i }
  table.map_column!('Resolutions') do |resolution|
    width, height = resolution.split("x").map {|res| res.strip.to_i }
    { width: width, height: height }
  end

  table.hashes.each do |resolutions|
    Resolution.define resolutions[:resolution], resolutions[:weight]
  end
end

Given(/^that a Traffic Spy server is running at '([^']+)'$/) do |server|
  TrafficSpy.configure(server)
end

Given(/^that the '([^']+)' source is defined with root url '([^']+)'$/) do |source_name,root_url|
  source = Source.new source_name, root_url
  source.create
  @current_source = source
end

Given(/^a campaign, named '([^']+)', composed with events: '([^']+)'$/) do |campaign,events|
  events = events.split(",").map {|event| event.strip }
  @current_source.create_campaign(campaign,events)
end

When(/^I submit (\d+) requests:$/) do |amount, table|
  table.map_headers!("URL" => :url,"Response Time" => :response_time,"Weight" => :weight,"Event" => :event,"VERB" => :verb)
  table.map_column!("Weight") { |weight| weight.to_i }
  table.map_column!("URL") { |url| "#{@current_source.root_url}#{url}" }
  table.map_column!("Response Time") do |response|
    first, last = response.split("..").map {|number| number.to_i }
    (first..last)
  end

  table.hashes.each do |row|
    weight = row.delete(:weight)
    Request.define row.merge(source: @current_source.name), weight
  end

  amount.to_i.times { Request.generate }
end