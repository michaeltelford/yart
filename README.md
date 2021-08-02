# YART

*Yet Another Ruby Templater* is yet another way to turn plain Ruby into HTML.

Makes building the changable bits of a webpage super easy and intuitive e.g. a form for posting to the server.

- YART provides an intuitive DSL that feels natural to use and removes the boiler plate from writing HTML
- YART can be used stand alone or embedded inside a higher level templater such as `erb` or `slim`
- YART has zero runtime dependencies and ~100 LOC
- YART is fully unit tested

## Example Usage

> login.html

```ruby
require "yart"

YART.parse do
  form action: "/auth" do
    input type: :email, placeholder: "Email Address", required: true, close: true
    input type: :password, placeholder: "Password", required: true, close: true
    button(type: :submit, id: :login) { "Login" }
  end
end
```

Which generates:

```html
<form action='/auth'>
  <input type='email' placeholder='Email Address' required>
  <input type='password' placeholder='Password' required>
  <button type='submit' id='login'>Login</button>
</form>
```

Note that the above HTML snippet is *prettified* for demonstration. The actual generated HTML will be *minified*.

## Installation

### RubyGems

    $ gem install yart

### Bundler

    $ bundle add yart

## API

The best way to fully demonstrate the YART API is with a more complex example:

```ruby
require 'yart'

YART.parse do
  element "!DOCTYPE", html: true, close: true # AKA `doctype`
  html lang: :en do
    head do
      title { "YART API" }
    end
    body do
      h1 { "Use a block to return a String of innerText or more elements" }
      div data_test_id: "String attribute values will be parsed as is" do
        h2(data_x: :sub_heading) { "Symbol attribute keys/values will be kebab-cased" }
        text { "Set the div's innerText, before and after its child elements" }
        p(class: [:content, :italic_text], id: :paragraph) do
          "You can pass an array of attribute values and they will be space separated"
        end
      end
      footer # Render an empty <footer></footer> element
    end
  end
end
```

Which generates, minifies and returns the following HTML5 from `YART.parse`:

```html
<!DOCTYPE html>
<html lang='en'>
<head>
  <title>YART API</title>
</head>
<body>
  <h1>Use a block to return a String of innerText or more elements</h1>
  <div data-test-id='String attribute values will be parsed as is'>
    <h2 data-x='sub-heading'>Symbol attribute keys/values will be kebab-cased</h2>
    Set the div's innerText before and after its child elements
    <p class='content italic-text' id='paragraph'>
      You can pass an array of attribute values and they will be space separated
    </p>
  </div>
  <footer></footer>
</body>
</html>
```

Let's look into what's happening under the hood in more detail:

`TODO`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/michaeltelford/yart. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/michaeltelford/yart/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YART project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/michaeltelford/yart/blob/master/CODE_OF_CONDUCT.md).
