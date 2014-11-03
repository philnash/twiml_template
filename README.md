# TwimlTemplate

[TwiML](https://www.twilio.com/docs/api/twiml) templates for Tilt.

An easy way to work with TwiML for responding to [Twilio](http://twilio.com) webhooks in Rails or Sinatra applications using template files.

[![Build Status](https://travis-ci.org/philnash/twiml_template.svg)](https://travis-ci.org/philnash/twiml_template)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twiml_template'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twiml_template

## Usage

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
  twiml.Say "Hello #{@name}"
```

Save the file as `#{RAILS_ROOT}/app/controller/voice/index.twiml`.

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
  twiml.Say "Hello #{@name}"
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
