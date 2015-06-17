require 'faraday'
require 'json'
class GoogleContacts::Account

  GOOGLE_DOMAIN = "https://www.google.com"

  attr_accessor :email, :connection

  def initialize(options={})
    self.email = options[:email] || "default"
    self.connection = Faraday.new(url: GOOGLE_DOMAIN) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def contacts
    ContactsCollectionProxy.new(self)
  end

  def get(path, params={})
    connection.get path, params.merge({alt: "json"})
  end

end

class CollectionProxy
  attr_accessor :account
  def initialize(account)
    self.account = account
  end
  def all
  end
  def where(params={})
  end
  def find(id)
  end
end
class ContactsCollectionProxy < CollectionProxy
  def all
    account.get "/m8/feeds/contacts/default/full"
  end
  def find(id)
    response = account.get "/m8/feeds/contacts/default/full/#{id}"
    json = JSON.parse(response.body)
    GoogleContacts::Contact.new(json["entry"])
  end
  def where(params={})
    response = account.get "/m8/feeds/contacts/default/full", params
    json = JSON.parse(response.body)
    json["entry"].collect do |entry|
      GoogleContacts::Contact.new(entry)
    end
  end
end