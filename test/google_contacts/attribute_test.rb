require 'minitest_helper'
require 'json'
class AttributeTest < Minitest::Test

  test "value returns value if present" do
    assert_equal "v", GoogleContacts::Attribute.new({"value" => "v"}).value
  end

  test "value returns $t if value is not present" do
    assert_equal "v", GoogleContacts::Attribute.new({"$t" => "v"}).value
  end

  test "can turn lower_snake_case method into lowerCamelCase" do
    assert_equal "fooBarBaz", GoogleContacts::Attribute.method_to_attribute_name(:foo_bar_baz)
  end

  test "can singularize method name" do
    assert_equal "email", GoogleContacts::Attribute.method_to_attribute_name(:emails)
  end

  test "Attribute Array returned for nice value when Array" do
    attribute = GoogleContacts::Attribute.new({
      "gd$email" => [
        {"$t" => "roger@homeplace.com"}
      ]
    })

    array = attribute.emails
    assert array.is_a? GoogleContacts::AttributeArray
    assert array.all? { |item| item.is_a? GoogleContacts::Attribute }
  end

  test "Attribute returned for nice value when Hash" do
    attribute = GoogleContacts::Attribute.new({
      "gd$id" => {"$t" => "roger@homeplace.com"}
    })

    id = attribute.id
    assert id.is_a? GoogleContacts::Attribute
  end

  test "untouched value returned for nice value when something else" do
    attribute = GoogleContacts::Attribute.new({
      "gd$id" => 123
    })

    assert_equal 123, attribute.id
  end

  test "boolean method returns true when value is true" do
    attribute = GoogleContacts::Attribute.new({
      "gd$primary" => "true"
    })

    assert_equal true, attribute.primary?
  end

  test "boolean method returns false when value is false" do
    attribute = GoogleContacts::Attribute.new({
      "gd$primary" => "false"
    })

    assert_equal false, attribute.primary?
  end

  test "boolean method returns false when value is missing" do
    attribute = GoogleContacts::Attribute.new({})

    assert_equal false, attribute.primary?
  end

end
