# GoogleContacts

This gem attempts to be a nicer wrapper around the ancient Google Contacts v3
API (emphasis on attempts!)

The problem lies in their janky representation of data. This gem tries to hide
that complexity by trying its best to return Ruby objects which can respond to
nice methods and return the right thing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_contacts'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google_contacts

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/google_contacts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
