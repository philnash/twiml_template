require 'twilio-ruby'

module TwimlTemplate
  class Response
    MESSAGING_VERBS = [:message, :redirect]
    VOICE_VERBS = [:say, :play, :dial, :gather, :pause, :enqueue, :hangup, :leave, :record, :redirect, :reject, :sms, :connect, :autopilot, :pay, :start]

    def initialize
      @voice_response = Twilio::TwiML::VoiceResponse.new
      @messaging_response = Twilio::TwiML::MessagingResponse.new

      yield(self) if block_given?
    end

    def to_xml
      twiml_response = @messaging_response || @voice_response
      twiml_response.to_xml
    end

    def method_missing(method, *args, **kwargs, &block)
      if (respond_to?(method))
        if (MESSAGING_VERBS.include?(method) && @messaging_response)
          if ((MESSAGING_VERBS - VOICE_VERBS).include?(method))
            @voice_response = nil
          end
          @messaging_response.send(method, *args, **kwargs, &block)
        end
        if (VOICE_VERBS.include?(method) && @voice_response)
          if ((VOICE_VERBS - MESSAGING_VERBS).include?(method))
            @messaging_response = nil
          end
          @voice_response.send(method, *args, **kwargs, &block)
        end
      else
        raise ArgumentError.new("Method `#{method}` doesn't exist.")
      end
      return @messaging_response || @voice_response
    end

    def respond_to?(method, include_private = false)
      verbs = []
      verbs = verbs | MESSAGING_VERBS if @messaging_response
      verbs = verbs | VOICE_VERBS if @voice_response
      verbs.include?(method.to_sym) || super
    end
  end
end