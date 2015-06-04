require 'minitest_helper'

class TestGoogleContacts < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GoogleContacts::VERSION
  end
end
