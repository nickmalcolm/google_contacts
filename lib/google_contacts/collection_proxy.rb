class CollectionProxy
  attr_accessor :base_path, :object_type
  def initialize(options={})
  end
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
  attr_accessor :group_id
  def initialize(options={})
    super
    self.base_path = "/m8/feeds/contacts/default/full"
    self.object_type = GoogleContacts::Contact
    self.group_id = options[:group_id]
  end
  def where(params={})
    if self.group_id
      params.merge!({group: group_id})
    end
    super(params)
  end
end

class GroupsCollectionProxy < CollectionProxy
  def initialize(options={})
    super
    self.base_path = "/m8/feeds/groups/default/full"
    self.object_type = GoogleContacts::Group
  end
end