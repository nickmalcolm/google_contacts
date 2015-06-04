require 'minitest_helper'
class AttributeArrayTest < Minitest::Test

  test "can find mobile phones" do
    mobile = GoogleContacts::Attribute.new({"rel" => "mobile", "$t" => "021 123 123"})
    home = GoogleContacts::Attribute.new({"rel" => "home", "$t" => "022 123 123"})
    array = GoogleContacts::AttributeArray.new([home, mobile])

    assert_equal [mobile], array.rel("mobile")
  end

  test "can find primary phones" do
    mobile = GoogleContacts::Attribute.new({"primary" => "true", "$t" => "021 123 123"})
    home = GoogleContacts::Attribute.new({"$t" => "022 123 123"})
    array = GoogleContacts::AttributeArray.new([home, mobile])

    assert_equal mobile, array.primary
  end

end