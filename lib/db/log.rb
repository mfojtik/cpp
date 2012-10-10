module DeltaControl

  class Log
    include DataMapper::Resource

    property :id, Serial

    property :method, String
    property :uri, String
    property :driver, String
    property :headers, String
    property :status, String
    property :params, Text

    belongs_to :user
    belongs_to :account

  end

end
