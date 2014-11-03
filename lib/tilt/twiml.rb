require 'twilio-ruby'
require 'tilt'

module Tilt
  class TwiML < Template
    self.default_mime_type = 'text/xml'

    def prepare; end

    def evaluate(scope, locals, &block)
      return super(scope, locals, &block) if data.respond_to?(:to_str)
      twiml = ::Twilio::TwiML::Response.new do |response|
        data.call(response)
      end.to_xml
    end

    def precompiled_template(local_keys)
      data.to_str
    end

    def precompiled_preamble(locals)
      return super if locals.include? :twiml
      "::Twilio::TwiML::Response.new do |twiml|\n#{super}"
    end

    def precompiled_postamble(locals)
      "end.to_xml"
    end
  end

  if defined? register_lazy
    register_lazy 'Tilt::TwiML', 'tilt/twiml', 'twiml'
  else
    register TwiML, '.twiml'
  end
end
