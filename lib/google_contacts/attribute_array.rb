class GoogleContacts::AttributeArray < Array

  # Public: Attributes often have a rel attribute. This is a helper
  # to get only values whose rel matches the given value.
  def rel(value)
    self.select {|attribute| attribute.rel.eql?(value)}
  rescue NoMethodError => e
    nil
  end

end