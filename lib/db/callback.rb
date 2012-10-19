module DeltaControl

  class Callback
    include DataMapper::Resource

    property :id, Serial

    property :resource, String
    property :resource_id, String
    property :condition, String
    property :url, String
    property :retries, Integer, :default => 0
    property :state, Enum[:active, :failed, :notified], :default => :active

    belongs_to :account

    def notify!
      begin
        RestClient.post url, self.to_xml
        update(:state => :notified)
      rescue => e
        puts "WARNING: Callback #{id} failed to notify #{url}: #{e.message}"
        update(:state => :failed)
      end
    end

    def self.active
      all(:state => :active)
    end

    def to_xml
      "<callback id='#{id}'><#{resource} id='#{resource_id}'>#{condition}</#{resource}></callback>"
    end

    @queue = :high

    def self.perform(callback_id)
      callback = get(callback_id)
      obj = callback.account.client.send(callback.resource, :id => callback.resource_id)
      prop, value = callback.condition.split('=')
      puts "#{prop}=#{value}"
      puts obj.inspect
      if obj.send(prop) == value
        callback.notify!
      else
        callback.update!(:retries => callback.retries + 1)
      end
    end

  end
end
