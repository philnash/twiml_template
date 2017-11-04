# TwimlTemplate

[TwiML](https://www.twilio.com/docs/api/twiml) templates for Tilt.

An easy way to work with TwiML for responding to [Twilio](http://twilio.com) webhooks in Rails or Sinatra applications using template files with a `.twiml` extension.

[![Build Status](https://travis-ci.org/philnash/twiml_template.svg)](https://travis-ci.org/philnash/twiml_template) [![Code Climate](https://codeclimate.com/github/philnash/twiml_template/badges/gpa.svg)](https://codeclimate.com/github/philnash/twiml_template)

## Example

If you create a template called `hello_world.twiml` with the following code:

```ruby
twiml.say("Hello World!")
```

and rendered it from an application you would get the following response:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Hello World!</Say>
</Response>
```

See [Rails](#rails) or [Sinatra](#sinatra) below for full instructions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twiml_template'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install twiml_template

## Usage

`twiml_template` allows you to use a template with the extension `.twiml` to write TwiML. The template makes a single variable, `twiml` available. `twiml` is an instance of a `TwimlTemplate::Response` which unifies the `twilio-ruby` gem's `Twilio::TwiML::VoiceResponse` and `Twilio::TwiML::MessagingResponse` classes. This means you only need one type of template file, but you can use it for either voice or messaging responses. `twiml_template` passes methods through to objects of each of those classes to generate the response.

If you start writing a voice response, you can only continue writing a voice response. If you start writing a messaging response, you can only continue with a messaging response. This should never cause you a problem (you would never normally write a response with a `<Say>` and a `<Message>` in it!).

### Rails

By including the `twiml_template` gem in your Rails project Gemfile you will be able to write TwiML templates easily.

Create a controller, like below:

```ruby
class VoiceController < ApplicationController
  def index
    @name = "World"
  end
end
```

Add a route:

```ruby
Rails.application.routes.draw do
  get 'voice' => 'voice#index'

  # Other routes...
end
```

And then add your TwiML view:

```ruby
  twiml.say "Hello #{@name}"
```

Save the file as `#{RAILS_ROOT}/app/views/voice/index.twiml`.

Run the app using `rails s` and visit [http://localhost:3000/voice](http://localhost:3000/voice) and you will see:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Hello World!</Say>
</Response>
```

### Sinatra

Create your application file like below:

```ruby
require 'sinatra'
require 'sinatra/twiml'

helpers Sinatra::TwiML

get '/voice' do
  @name = "World!"
  twiml :voice
end
```

And then add your TwiML view:

```ruby
  twiml.say "Hello #{@name}"
```

Save the file as `#{APP_ROOT}/views/voice.twiml`.

Start the app with `ruby app.rb` and visit [http://localhost:4567/voice](http://localhost:4567/voice) and you will see:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say>Hello World!</Say>
</Response>
```

## Contributing

1. Fork it ( https://github.com/philnash/twiml_template/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
