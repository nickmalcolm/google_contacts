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