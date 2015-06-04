# GoogleContacts

This gem attempts to be a nicer wrapper around the ancient Google Contacts v3
API (emphasis on attempts!)

The problem lies in their janky representation of data. This gem tries its best
to hide that complexity by returning Ruby objects which can respond to
nice methods and return the right thing.

References:

  - [Google Contact V3 API](https://developers.google.com/google-apps/contacts/v3/)
  - [Google Contact "Kind"](https://developers.google.com/gdata/docs/2.0/elements?csw=1#gdContactKind)
  - [Google Data JSON Documentation](https://developers.google.com/gdata/docs/json)

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

The tests provide some nice examples showing how Contacts can be used. While
the Client for actually fetching the JSON isn't yet implemented, the tests read
from stubbed files.

You can then see that regular method calls are handled and transparently read
the JSON for you.

It handles plurals for fetching arrays, questions? for getting booleans, on top
of any other method you try to throw at it.

Something like this:

    > contact = GoogleContacts::Contact.new({
      "entry": {
        "updated": {
          "$t": "2015-01-22T22:21:46.684Z"
        },
        "gd$name": {
          "gd$familyName": {
            "$t": "Krinklecut"
          },
          "gd$givenName": {
            "$t": "Mike"
          },
          "gd$fullName": {
            "$t": "Mike Krinklecut"
          }
        },
        "title": {
          "$t": "Mike Krinklecut"
        },
        "gd$email": [
          {
            "primary": "true",
            "rel": "http://schemas.google.com/g/2005#other",
            "address": "krinkle@chippies.com"
          }
        ]
      }
    })

    > contact.name.full_name.value
    => "Mike Krinklecut"
    > contact.title.value
    => "Mike Krinklecut"

    > email = contact.emails.first
    > email.address
    => "krinkle@chippies.com"
    > email.primary?
    => true

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/nickmalcolm/google_contacts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Alternatives

https://github.com/aliang/google_contacts_api seems to be the most popular.
