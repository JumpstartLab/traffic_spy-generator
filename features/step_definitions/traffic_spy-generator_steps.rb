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

Then(/^the results should be correctly represented$/) do
  # "SUCCESS"
end