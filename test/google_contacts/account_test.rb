require 'minitest_helper'
class AccountTest < Minitest::Test

  def setup
    @account = GoogleContacts::Account.new(email: "nick@example.com")
  end

  test "can get a collection of contacts" do
    # GoogleContacts::API.expects(:get).with()
    assert_equal [], @account.contacts.all
  end

  test "can get a single contact" do
    # GoogleContacts::API.expects(:get).with()
    assert_equal foo, @account.contacts.find("abc123")
  end

  test "can get all groups" do
    assert_equal [], @account.groups.all
  end

  test "can get a single groups" do
    assert_equal [], @account.groups.find("abc123")
  end


end