module TwimlTemplate
  class Response
    @@messaging_verbs = [:message, :redirect]
    @@voice_verbs = [:say, :play, :dial, :gather, :pause, :enqueue, :hangup, :leave, :record, :redirect, :reject, :sms]

    def initialize
      @voice_response = Twilio::TwiML::VoiceResponse.new
      @messaging_response = Twilio::TwiML::MessagingResponse.new

      yield(self) if block_given?
    end

    def to_xml
      twiml_response = @messaging_response || @voice_response
      twiml_response.to_xml
    end

    def method_missing(method, *args, &block)
      if (respond_to?(method))
        if (@@messaging_verbs.include?(method.to_sym) && @messaging_response)
          if ((@@messaging_verbs - @@voice_verbs).include?(method.to_sym))
            @voice_response = nil
          end
          @messaging_response.send(method.to_sym, *args, &block)
        end
        if (@@voice_verbs.include?(method.to_sym) && @voice_response)
          if ((@@voice_verbs - @@messaging_verbs).include?(method.to_sym))
            @messaging_response = nil
          end
          @voice_response.send(method.to_sym, *args, &block)
        end
      else
        raise ArgumentError.new("Method `#{method}` doesn't exist.")
      end
      return @messaging_response || @voice_response
    end

    def respond_to?(method, include_private = false)
      verbs = []
      verbs = verbs | @@messaging_verbs if @messaging_response
      verbs = verbs | @@voice_verbs if @voice_response
      verbs.include?(method.to_sym) || super
    end
  end
end