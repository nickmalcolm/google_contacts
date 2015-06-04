require 'minitest_helper'
require 'json'
class ContactsTest < Minitest::Test

  test "fetching a simple contact" do
    json = JSON.parse(File.open('test/stubs/contact.json').read)
    contact = GoogleContacts::Contact.new(json: json)
    assert_equal "http://www.google.com/m8/feeds/contacts/my%20email.com/base/42lIFeABC", contact.id.value
    assert_equal "Mike Krinklecut", contact.name.full_name.value
    assert_equal "Mike Krinklecut", contact.title.value
    assert_equal "2015-01-22T22:21:46.684Z", contact.updated.value

    assert_equal 1, contact.emails.count
    email = contact.emails.first
    assert_equal "krinkle@chippies.com", email.address
    assert email.primary?
  end

  test "fetching a complicated contact" do
    json = JSON.parse(File.open('test/stubs/complicated_contact.json').read)
    contact = GoogleContacts::Contact.new(json: json)

    assert_equal "Roger", contact.name.given_name.value
    assert_equal "Rodja", contact.name.given_name.yomi

    relation = contact.relations.first
    assert_equal "Nicole Foobary", relation.value
    assert_equal "spouse", relation.rel


    primary_email = contact.emails.primary
    assert_equal "roger@workplace.com", primary_email.address
    assert primary_email.primary?

    home_email = contact.emails.rel("home").first
    assert_equal "roger@homeplace.com", home_email.address
    assert !home_email.primary?

    mobile = "210001111"
    assert_equal mobile, contact.phone_numbers.first.value
    assert_equal mobile, contact.phone_numbers.rel("mobile").first.value

    expected_custom_field = {
      "value": "custom value yo!",
      "key": "Customer Field Yo!"
    }
    assert_equal expected_custom_field, contact.user_defined_fields.first

    assert_equal "1980-01-01", contact.birthday.when

    home_addr = contact.structed_postal_addresses.rel("home").first
    expected_addr = "23 Giddyup Road, Melonport, Australia"
    assert_equal expected_addr, home_addr.formatted_address.value
    assert_equal "Australia", home_addr.country.value
    assert_equal "AU", home_addr.country.code
  end

end
