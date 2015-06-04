class GoogleContacts::AttributeArray < Array

  # Public: Attributes often have a rel attribute.
  # Returns an array of Attributes whose rel matches the given value.
  def rel(value)
    self.select do |attribute|
      begin
        attribute.rel.eql?(value) || attribute.rel.end_with?(value)
      rescue NoMethodError => e
        false
      end
    end
  end

  # Public: Attributes often have a primary attribute.
  # Returns the first (should be only) Attribute with primary = true
  def primary
    self.find do |attribute|
      begin
        attribute.primary?
      rescue NoMethodError => e
        false
      end
    end
  end

end