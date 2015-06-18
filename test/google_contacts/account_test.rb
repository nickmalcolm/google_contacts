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

  test "can get a single contact" do
    expected = GoogleContacts::Contact.new({"foo" => "bar"})
    @stubs.get('/m8/feeds/contacts/default/full/a-contact?alt=json') do |env|
      [ 200, {}, '{"entry" : {"foo" : "bar"}}' ]
    end
    assert_equal expected, @account.contacts.find("a-contact")
  end

  test "can get contacts with filtering params" do
    expected = [GoogleContacts::Contact.new({"foo" => "bar"})]
    @stubs.get('/m8/feeds/contacts/default/full?alt=json&group=a-group') do |env|
      [ 200, {}, '{"entry" : [{"foo" : "bar"}]}' ]
    end
    assert_equal expected, @account.contacts.where(group: "a-group")
  end

  test "can get all contacts" do
    contacts = [stub()]
    ContactsCollectionProxy.any_instance.expects(:where).with().returns(contacts)
    assert_equal contacts, @account.contacts.all
  end



  test "can get a single group" do
    expected = GoogleContacts::Group.new({"foo" => "bar"})
    @stubs.get('/m8/feeds/groups/default/full/a-group?alt=json') do |env|
      [ 200, {}, '{"entry" : {"foo" : "bar"}}' ]
    end
    assert_equal expected, @account.groups.find("a-group")
  end

  test "can get a groups contacts" do
    group = GoogleContacts::Group.new({"foo" => "bar"})
    contacts = [stub()]
    ContactsCollectionProxy.any_instance.expects(:where).with(group: "a-group").returns(contacts)
    assert_equal contacts, group.contacts.all
  end


end