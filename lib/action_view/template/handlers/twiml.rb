require 'twilio-ruby'

module ActionView
   module Template::Handlers
    class TwiML
      def self.call(template)
        "self.output_buffer = ::Twilio::TwiML::Response.new do |twiml|;" +
        template.source +
        ";end.to_xml;"
      end
    end
  end
end
