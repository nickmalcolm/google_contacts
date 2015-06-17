require 'minitest_helper'
require 'faraday'
class AccountTest < Minitest::Test

  def setup
    @account_id = "foo@bar.com"
    @account = GoogleContacts::Account.new(email: @account_id)
    @stubs = Faraday::Adapter::Test::Stubs.new
    @account.connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

  end

  test "can get a collection of contacts" do
    # GoogleContacts::API.expects(:get).with()
    # assert_equal [], @account.contacts.all
  end

  test "can get a single contact" do
    expected = GoogleContacts::Contact.new({"foo" => "bar"})
    @stubs.get('/m8/feeds/contacts/default/full/a-contact?alt=json') do |env|
      [ 200, {}, '{"entry" : {"foo" : "bar"}}' ]
    end
    assert_equal expected, @account.contacts.find("a-contact")
  end

  test "can get all groups" do
    # assert_equal [], @account.groups.all
  end

  test "can get a single group" do
    # assert_equal [], @account.groups.find("abc123")
  end

  test "can get a group's contacts" do
    expected = [GoogleContacts::Contact.new({"foo" => "bar"})]
    @stubs.get('/m8/feeds/contacts/default/full?alt=json&group=a-group') do |env|
      [ 200, {}, '{"entry" : [{"foo" : "bar"}]}' ]
    end
    assert_equal expected, @account.contacts.where(group: "a-group")
  end


end