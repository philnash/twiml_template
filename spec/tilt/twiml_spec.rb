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
      template = Tilt::TwiML.new { |t| "twiml.say message: 'Hello World!'" }
      template.render.must_be_equivalent_xml twiml_response
    end

    it "can be rendered more than once" do
      template = Tilt::TwiML.new { |t| "twiml.say message: 'Hello World!'" }
      3.times { template.render.must_be_equivalent_xml twiml_response }
    end
  end

  describe 'rendering with locals/scopes' do

    let :twiml_response do
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response>" \
      "<Say>Hello Joe!</Say></Response>"
    end

    it "passes locals" do
      template = Tilt::TwiML.new do |t|
        "twiml.say message: 'Hello ' + name + '!'"
      end
      template.render(Object.new, :name => 'Joe').must_be_equivalent_xml twiml_response
    end

    it "evaluates in an object scope" do
      template = Tilt::TwiML.new do |t|
        "twiml.say message: 'Hello ' + @name + '!'"
      end
      scope = Object.new
      scope.instance_variable_set :@name, 'Joe'
      template.render(scope).must_be_equivalent_xml twiml_response
    end

    it "passes a block for yield" do
      template = Tilt::TwiML.new do |t|
        "twiml.say message: 'Hello ' + yield + '!'"
      end
      3.times { template.render { 'Joe' }.must_be_equivalent_xml twiml_response }
    end

    it "takes block style templates" do
      template =
        Tilt::TwiML.new do |t|
          lambda { |twiml| twiml.say(message: 'Hello Joe!') }
        end
      template.render.must_be_equivalent_xml twiml_response
    end
  end
end
