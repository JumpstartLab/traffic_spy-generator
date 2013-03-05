# TrafficSpy::Generator

## Usage

* Install Generator Dependencies

```
$ bundle
```

* Update the Cucumber Feature file `features/traffic_spy.feature` to include your server information

```gherkin
Feature: Traffic Spy
  As a traffic spy customer
  I am able to able to register with the service
  And submit request data to have it aggregated

  Background:
    Given that a Traffic Spy server is running at 'http://YOURSITE:PORT'
```

* Run Cucumber

```
$ cucumber
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
