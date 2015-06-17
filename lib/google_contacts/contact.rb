require 'uri'
# Public: a GoogleContact.
# Should be initialized with a JSON "entry"
class GoogleContacts::Contact < GoogleContacts::Attribute

  DEFAULT_ATTRIBUTES = %w(title emails name deleted name organization
    phone_numbers structured_postal_addresses postal_address where content
    user_defined_fields birthday relation)

  # When an attribute isn't set, it won't be returned in the JSON at all.
  # These should return nil instead of raising NoMethodErrors
  DEFAULT_ATTRIBUTES.each do |attribute|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{attribute}                  # def title
        method_missing(:#{attribute})   #   method_missing(:title)
      rescue NoMethodError => e         # rescue NoMethodError => e
        nil                             #   nil
      end                               # end
    RUBY
  end

  def save
    save!
    # rescue some exceptions
  end

  def save!
    if exists?
      edit_endpoint = URI.parse(links.rel("edit").first.href).path
      GoogleContacts::Account.service.put(edit_endpoint, body: {entry: json})
    else
      new_endpoint = "/m8/feeds/contacts/default/full"
      GoogleContacts::Account.service.post(new_endpoint, body: {entry: json})
    end
  end

  def exists?
    # HEAD request
  end

end