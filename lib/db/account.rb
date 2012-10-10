module DeltaControl

  class UserAccount
    include DataMapper::Resource

    belongs_to :user, :key => true
    belongs_to :account, :key => true
  end

  class User
    include DataMapper::Resource

    property :id, Serial
    property :name, String, :required => true, :unique => true
    property :password, String
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :user_accounts
    has n, :accounts, :through => :user_accounts
    has n, :logs

    def own_accounts
      accounts.all(:created_by => self.id)
    end

    def available_accounts
      accounts.all + Account.all(:visibility => :public)
    end

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
    property :name, String, :required => true, :unique => true
    property :driver, String, :required => true
    property :provider, Text
    property :username, String
    property :password, String
    property :created_at, DateTime
    property :created_by, Integer, :required => true
    property :updated_at, DateTime
    property :visibility, Enum[:private, :public], :default => :private

    has n, :user_accounts
    has n, :users, :through => :user_accounts
    has n, :logs

    def owner
      User.get(created_by)
    end

    def healthy?
      begin
        !Deltacloud::Library.new(
          driver.to_sym,
          :user => username,
          :password => password,
          :provider => provider
        ).realms.empty?
      rescue => e
        p e.message
        false
      end
    end

  end


end
