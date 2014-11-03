require 'tilt/twiml'

module Sinatra
  module TwiML
    def twiml(template = nil, options = {}, locals = {}, &block)
      options[:default_content_type] = :xml
      render_ruby(:twiml, template, options, locals, &block)
    end
  end
end
