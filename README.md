# TrafficSpy::Generator

## Usage

* Install Generator Dependencies

```
$ bundle
```

* Update the Cucumber Feature to include your server information

```gherkin
  Background:
    Given that a Traffic Spy server is running at 'YOURSITE'
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
