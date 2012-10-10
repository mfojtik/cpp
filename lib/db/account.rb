module DeltaControl

  class User
    include DataMapper::Resource

    property :id, Serial
    property :name, String
    property :password, String

    has n, :accounts
    has n, :logs

    def to_struct
      OpenStruct.new(
        :name => self.name,
        :id => self.id
      )
    end
  end

  class Account
    include DataMapper::Resource

    property :id, Serial
    property :name, String
    property :driver, String
    property :provider, Text
    property :username, String
    property :password, String

    belongs_to :user
    has n, :logs

  end

end
