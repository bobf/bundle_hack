# Bundle Hack

Bundle Hack allows you to safely edit the source code for any gem in your bundle so you can debug fearlessly. When you're done, you can restore gems to their previous state.

All changes are made local to your bundle and very little magic is used.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bundle_hack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bundle_hack

## Usage

Pick a gem from your `Gemfile` and begin hacking:

``` bash
$ bundle hack rake
```

The gem is copied to `hack/rake/` (relative to the same directory as your `Gemfile`).

When you're done, you can restore a specific gem:

# TODO:

``` bash
$ bundle hack:restore rake
```

# TODO:

Or restore all hacked gems:
```
$ bundle hack:restore:all
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bobf/bundle_hack
