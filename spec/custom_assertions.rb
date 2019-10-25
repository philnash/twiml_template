require 'minitest/assertions'
require 'minitest/spec'
require 'equivalent-xml'
require 'nokogiri'

module Minitest::Assertions
  def assert_equivalent_xml(expected, actual)
    expected = parse(expected) unless expected.is_a?(Nokogiri::XML::Document)
    actual = parse(actual) unless actual.is_a?(Nokogiri::XML::Document)
    assert EquivalentXml.equivalent?(expected, actual, opts = { :element_order => true, :normalize_whitespace => false }), "Expected XML to be equivalent. Expected:\n\n#{expected.to_s} \n\nReceived:\n\n#{actual.to_s}"
  end

  private

  def parse(string)
    Nokogiri::XML::Document.parse(string.to_s, &:noblanks)
  end
end

module Minitest::Expectations
  String.infect_an_assertion :assert_equivalent_xml, :must_be_equivalent_xml
end