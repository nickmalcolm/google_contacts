# Public: a Group of contacts.
# Should be initialized with a JSON "entry"
class GoogleContacts::Group < GoogleContacts::Attribute

  def contacts
    ContactsCollectionProxy.new(group_id: id.value)
  end

end