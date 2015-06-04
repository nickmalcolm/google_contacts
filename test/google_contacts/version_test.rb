require 'minitest_helper'

class VersionTest < Minitest::Test

  test "version number is not nil" do
    refute_nil ::GoogleContacts::VERSION
  end

end
