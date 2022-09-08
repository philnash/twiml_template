require 'twilio-ruby'

module ActionView
   module Template::Handlers
    class TwiML
      def self.call(template, source = nil)
        "self.output_buffer = ::TwimlTemplate::Response.new do |twiml|;" +
        (source || template.source) +
        ";end.to_xml;"
      end
    end
  end
end
