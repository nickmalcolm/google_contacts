require 'active_support/inflector'
# Public: Attribute does a lot of magic using the method_missing pattern.
# It allows method calls to access hash values in the myriad ways Google has
# decided to store them.
# It also allows ruby-esque methods to be used.
#
# Examples:
#
#   attribute = Attribute.new({
#     "gd$email" => [
#       {
#         "primary" => "true",
#         "address" => "foo@bar.com"
#       }
#     ]
#   })
#   attribute.emails.first.primary? # => true
#   attribute = Attribute.new({
#     "id" => {
#       "$t" => "abc123"
#     }
#   })
#   attribute.id.value # => "abc123"
#
class GoogleContacts::Attribute

  def initialize(json)
    @json = json
  end

  # Public: returns whatever Google put at "$t"
  def value
    @json["value"] || @json["$t"]
  end

  # We'll try support any method thrown at the contact by looking for relevant
  # attributes in the JSON
  def method_missing(method, *args, &block)
    attr_name = self.class.method_to_attribute_name(method)

    # Check if they're asking a question
    if attr_name.end_with?("?")
      booleanize = true
      attr_name = attr_name[0..-2]
    end

    # First, let's look for an attribute exactly named `method`
    if @json.has_key?(attr_name)
      key = attr_name
    # It might be prefixed with something and delimited with $
    elsif (first_match = @json.keys.find {|key| key.split("$").last.eql? attr_name.to_s})
      key = first_match

    # We don't know what this is.
    else
      # If they're trying to get a boolean, and the attribute doesn't exist,
      # lets return false. (E.g. primary? for an Attribute without an attr
      # called primary)
      return false if booleanize
      # Otherwise give up
      return super
    end

    nice_value_at_key(key, booleanize: booleanize)
  end

  # Public: Returns the value at a key wrapped in something appropriate.
  #
  # Parameters:
  #   key - required, the key in the JSON
  #   booleanize - optional (boolean), whether to return the truthyness
  #     of the value
  #
  # Returns:
  #   An Array of Hashes become an Array of Attributes
  #   A Hash becomes an Array
  #   Anything else stays as is (can be booleanized)
  def nice_value_at_key(key, booleanize: false)
    value = @json[key]

    # Wrap the value in an Array / Attribute as necessary
    if value.is_a? Array
      attributes = value.collect { |item| GoogleContacts::Attribute.new item }
      value = GoogleContacts::AttributeArray.new(attributes)
    elsif value.is_a? Hash
      value = GoogleContacts::Attribute.new value
    end

    # Turn into something truthy if booleanize
    if booleanize
      value = value.eql?("true")
    end

    # Stop messing with value now. :)
    value
  end

  # Public: will turn a method into a potential attribute name.
  # `.foo_bar_baz` => "fooBarBaz".
  # `.emails` => "email"
  def self.method_to_attribute_name(method)
    attr_name = method.to_s
    capitalize_first_letter = false
    attr_name = ActiveSupport::Inflector.camelize(attr_name, capitalize_first_letter)
    attr_name = ActiveSupport::Inflector.singularize(attr_name)
  end

end