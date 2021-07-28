# YART

*Yet Another Ruby Templater* is yet another way to turn ruby code into HTML.

Can be used stand alone or embedded inside a higher level templater such as `erb` or `slim`. Is super good at building the changable bits of a webpage e.g. a form for posting to the server etc.

## Usage

```ruby
require 'yart'

YART.parse do
    h1(id: :title) { 'YART' }
    div do
        h2 { 'Yet Another Ruby Templater' }
        p(class: [:content, :italic]) { 'Possibly the simplest way to turn sexy Ruby into boring HTML' }
        text { 'Ruby ruby ruby ruby aaaaahhhhhhawwwwwwwww' }
    end
    footer
end
```

Which produces and returns (from `YART.parse`):

```html
<h1 id='title'>YART</h1>
<div>
    <h2>Yet Another Ruby Templater</h2>
    <p class='content italic'>Possibly the simplest way to turn sexy Ruby into boring HTML</p>
    Ruby ruby ruby ruby aaaaahhhhhhawwwwwwwww
</div>
<footer></footer>
```

## Installation

### RubyGems

    $ gem install yart

### Bundler

    $ bundle add yart

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/michaeltelford/yart. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/michaeltelford/yart/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YART project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/michaeltelford/yart/blob/master/CODE_OF_CONDUCT.md).
