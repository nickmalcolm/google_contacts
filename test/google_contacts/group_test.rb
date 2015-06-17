require 'minitest_helper'
require 'json'
class GroupTest < Minitest::Test

  test "fetching a group" do
    json = JSON.parse(File.open('test/stubs/group.json').read)
    group = GoogleContacts::Group.new(json["entry"])
    assert_equal "http://www.google.com/m8/feeds/groups/me%40example/base/abc123", group.id.value
    assert_equal "This is a group", group.title.value
    assert_equal "This is a group", group.content.value
    assert_equal "2015-06-05T05:21:28.403Z", group.updated.value
  end

end
