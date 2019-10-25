require 'spec_helper'
require 'twiml_template/response'

describe TwimlTemplate::Response do
  let(:response) { TwimlTemplate::Response.new }

  describe 'with a messaging response' do
    describe 'with a simple response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
        "<Message>Hello World!</Message></Response>"
      end

      it 'generates successfully' do
        response.message(body: "Hello World!")
        expect(response.to_xml).must_be_equivalent_xml twiml
      end

      [:message, :redirect].each do |verb|
        it "responds to #{verb}" do
          expect(response).must_respond_to(verb)
        end
      end
    end

    describe 'with a nested response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
        "<Message><Body>Hello World!</Body></Message></Response>"
      end

      it 'generates successfully' do
        response.message do |msg|
          msg.body "Hello World!"
        end
        expect(response.to_xml).must_be_equivalent_xml twiml
      end
    end

    describe 'with multiple commands' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
        "<Message>Hello World!</Message><Redirect>http://example.com</Redirect></Response>"
      end

      it 'generates successfully' do
        response.message(body: "Hello World!")
        response.redirect("http://example.com")
        expect(response.to_xml).must_be_equivalent_xml twiml
      end
    end
  end

  describe 'with a voice response' do
    describe 'with a simple response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
        "<Say>Hello World!</Say></Response>"
      end

      it 'generates successfully' do
        response.say(message: "Hello World!")
        expect(response.to_xml).must_be_equivalent_xml twiml
      end

      (TwimlTemplate::Response::MESSAGING_VERBS | TwimlTemplate::Response::VOICE_VERBS).each do |verb|
        it "responds to #{verb}" do
          expect(response).must_respond_to(verb)
        end
      end
    end

    describe 'with a nested response' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
        "<Gather><Say>Hello World!</Say></Gather></Response>"
      end

      it 'generates successfully' do
        response.gather do |gather|
          gather.say message: "Hello World!"
        end
        expect(response.to_xml).must_be_equivalent_xml twiml
      end
    end

    describe 'with multiple commands' do
      let :twiml do
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
        "<Say>Hello World!</Say><Play>http://tunes.com</Play></Response>"
      end

      it 'generates successfully' do
        response.say(message: "Hello World!")
        response.play(url: "http://tunes.com")
        expect(response.to_xml).must_be_equivalent_xml twiml
      end
    end
  end

  describe 'with a mixed response' do
    it 'should raise an error' do
      expect(proc do
        response.say(message: "Hello")
        response.message(" World!")
      end).must_raise ArgumentError
    end

    it 'should allow a redirect and a message' do
      expect(proc do
        response.redirect("http://example.com")
        response.message(body: "Hello World!")
      end).must_be_silent
    end

    it 'should allow a redirect and a voice verb' do
      expect(proc do
        response.redirect("http://example.com")
        response.say(message: "Hello World!")
      end).must_be_silent
    end
  end
end