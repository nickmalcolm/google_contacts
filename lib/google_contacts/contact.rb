class GoogleContacts::Contact

  # Public: initializes a Contact using Google Contacts API JSON data
  def initialize(json: {})
    @json = json
    @entry = GoogleContacts::Attribute.new(@json["entry"])
  end

  # Send any missing methods to our magical entry
  def method_missing(method, *args, &block)
    @entry.send(method, *args, &block)
  rescue NoMethodError => error
    super
  end

end