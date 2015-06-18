require 'faraday'
require 'json'
class GoogleContacts::Account

  GOOGLE_DOMAIN = "https://www.google.com"

  attr_accessor :email, :connection

  class << self
    attr_accessor :service

    def initialize_service(options={})
      self.service = new(options)
    end
  end

  def initialize(options={})
    self.email = options[:email] || "default"
    self.connection = Faraday.new(url: GOOGLE_DOMAIN) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def contacts
    ContactsCollectionProxy.new
  end

  def groups
    GroupsCollectionProxy.new
  end

  def get(path, params={})
    connection.get path, params.merge({alt: "json"})
  end

end

class CollectionProxy
  attr_accessor :base_path, :object_type
  def all
    where # an empty where query = all :)
  end
  def where(params={})
    response = GoogleContacts::Account.service.get base_path, params
    json = JSON.parse(response.body)
    json["entry"].collect do |entry|
      object_type.new(entry)
    end
  end
  def find(id)
    response = GoogleContacts::Account.service.get "#{base_path}/#{id}"
    json = JSON.parse(response.body)
    object_type.new(json["entry"])
  end
end
class ContactsCollectionProxy < CollectionProxy
  def initialize(*args)
    super
    self.base_path = "/m8/feeds/contacts/default/full"
    self.object_type = GoogleContacts::Contact
  end
end
class GroupsCollectionProxy < CollectionProxy
  def initialize(*args)
    super
    self.base_path = "/m8/feeds/groups/default/full"
    self.object_type = GoogleContacts::Group
  end
end