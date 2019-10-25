$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'bundler'
Bundler.setup

require 'minitest/autorun'
require 'minitest/mock'
require_relative './custom_assertions.rb'