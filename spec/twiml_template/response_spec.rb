require 'spec_helper'
require 'twiml_template/response'

describe TwimlTemplate::Response do
  let(:response) { TwimlTemplate::Response.new }

  describe 'with a messaging response' do
    describe 'with a simple response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n" \
        "<Message>Hello World!</Message>\n</Response>\n"
      end

      it 'generates successfully' do
        response.message(body: "Hello World!")
        response.to_xml.must_equal twiml
      end

      [:message, :redirect].each do |verb|
        it "responds to #{verb}" do
          response.must_respond_to(verb)
        end
      end
    end

    describe 'with a nested response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n" \
        "<Message>\n<Body>Hello World!</Body>\n</Message>\n</Response>\n"
      end

      it 'generates successfully' do
        response.message do |msg|
          msg.body "Hello World!"
        end
        response.to_xml.must_equal twiml
      end
    end

    describe 'with multiple commands' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n" \
        "<Message>Hello World!</Message>\n<Redirect>http://example.com</Redirect>\n</Response>\n"
      end

      it 'generates successfully' do
        response.message(body: "Hello World!")
        response.redirect("http://example.com")
        response.to_xml.must_equal twiml
      end
    end
  end

  describe 'with a voice response' do
    describe 'with a simple response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n" \
        "<Say>Hello World!</Say>\n</Response>\n"
      end

      it 'generates successfully' do
        response.say(message: "Hello World!")
        response.to_xml.must_equal twiml
      end

      (TwimlTemplate::Response::MESSAGING_VERBS | TwimlTemplate::Response::VOICE_VERBS).each do |verb|
        it "responds to #{verb}" do
          response.must_respond_to(verb)
        end
      end
    end

    describe 'with a nested response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n" \
        "<Gather>\n<Say>Hello World!</Say>\n</Gather>\n</Response>\n"
      end

      it 'generates successfully' do
        response.gather do |gather|
          gather.say message: "Hello World!"
        end
        response.to_xml.must_equal twiml
      end
    end

    describe 'with multiple commands' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n" \
        "<Say>Hello World!</Say>\n<Play>http://tunes.com</Play>\n</Response>\n"
      end

      it 'generates successfully' do
        response.say(message: "Hello World!")
        response.play(url: "http://tunes.com")
        response.to_xml.must_equal twiml
      end
    end
  end

  describe 'with a mixed response' do
    it 'should raise an error' do
      proc do
        response.say(message: "Hello")
        response.message(" World!")
      end.must_raise ArgumentError
    end

    it 'should allow a redirect and a message' do
      proc do
        response.redirect("http://example.com")
        response.message(body: "Hello World!")
      end.must_be_silent
    end

    it 'should allow a redirect and a voice verb' do
      proc do
        response.redirect("http://example.com")
        response.say(message: "Hello World!")
      end.must_be_silent
    end
  end


end