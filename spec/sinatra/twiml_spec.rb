require 'spec_helper'
require 'rack/test'
require 'sinatra/base'
require 'sinatra/twiml'

class TwiMLApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  helpers Sinatra::TwiML

  get "/hello" do
    twiml :hello, locals: {name: 'Joe'}
  end
end

describe Sinatra::TwiML do
  include Rack::Test::Methods

  let(:app) { TwiMLApp }

  let :twiml_response do
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n" \
    "<Say>Hello Joe!</Say>\n</Response>"
  end

  it "renders simple template" do
    response = get("/hello")
    response.body.strip.must_equal twiml_response
  end
end
