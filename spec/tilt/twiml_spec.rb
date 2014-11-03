require 'spec_helper'
require 'tilt/twiml'

describe Tilt::TwiML do
  it "registers for '.twiml' files" do
    Tilt['test.twiml'].must_equal Tilt::TwiML
    Tilt['test.xml.twiml'].must_equal Tilt::TwiML
  end

  describe 'simple rendering' do
    let :twiml_response do
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
      "<Say>Hello World!</Say></Response>"
    end

    it "prepares and evaluates the template on #render" do
      template = Tilt::TwiML.new { |t| "twiml.Say 'Hello World!'" }
      template.render.must_equal twiml_response
    end

    it "can be rendered more than once" do
      template = Tilt::TwiML.new { |t| "twiml.Say 'Hello World!'" }
      3.times { template.render.must_equal twiml_response }
    end
  end

  describe 'rendering with locals/scopes' do

    let :twiml_response do
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
      "<Say>Hello Joe!</Say></Response>"
    end

    it "passes locals" do
      template = Tilt::TwiML.new do |t|
        "twiml.Say 'Hello ' + name + '!'"
      end
      template.render(Object.new, :name => 'Joe').must_equal twiml_response
    end

    it "evaluates in an object scope" do
      template = Tilt::TwiML.new do |t|
        "twiml.Say 'Hello ' + @name + '!'"
      end
      scope = Object.new
      scope.instance_variable_set :@name, 'Joe'
      template.render(scope).must_equal twiml_response
    end

    it "passes a block for yield" do
      template = Tilt::TwiML.new do |t|
        "twiml.Say 'Hello ' + yield + '!'"
      end
      3.times { template.render { 'Joe' }.must_equal twiml_response }
    end

    it "takes block style templates" do
      template =
        Tilt::TwiML.new do |t|
          lambda { |twiml| twiml.Say('Hello Joe!') }
        end
      template.render.must_equal twiml_response
    end

    it "allows nesting raw XML" do
      subtemplate = '<Number>+447712345678</Number>'
      template = Tilt::TwiML.new { "twiml.Dial { twiml << yield }" }
      expected = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
                 "<Dial><Number>+447712345678</Number></Dial></Response>"
      3.times do
        template.render { subtemplate }.must_equal expected
      end
    end

  end
end
