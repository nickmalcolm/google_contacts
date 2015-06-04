$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'google_contacts'

require 'minitest/autorun'
require 'mocha/mini_test'

# Add declarative test methods, a la rails
#   test "foo bar" do
#     # test goes here
#   end
class Minitest::Test
  class << self # The def self.test way of doing it doesn't override Kernel.test but this does...
    def test(name, &block)
      method_name = "test_#{ name.gsub(/[\W]/, '_') }"
      if block.nil?
        define_method(method_name) do
          flunk "Missing implementation for test #{name.inspect}"
        end
      else
        define_method(method_name, &block)
      end
    end
  end
end