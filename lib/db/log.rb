module DeltaControl

  class Log
    include DataMapper::Resource

    property :id, Serial

    property :method, String
    property :uri, String
    property :driver, String
    property :headers, Text
    property :status, Integer
    property :params, Text
    property :body, Text
    property :created_at, DateTime
    belongs_to :user
    belongs_to :account

  end

end
