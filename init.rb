require 'sinatra/base'
require 'haml'
require 'ostruct'

require_relative './lib/helpers/views_helper.rb'
require_relative './lib/helpers/app_helper.rb'

require_relative './lib/db/account.rb'

module DeltaControl

  def self.config
    @@config ||= OpenStruct.new(
      YAML.load(File.read(File.join(File.dirname(__FILE__), 'conf', 'config.yml')))
    )
  end

  def self.db_seed
    User.create(:name => 'admin', :password => 'redhat') unless User.first(:name => 'admin')
  end

  def self.db_init
    DataMapper::Logger.new($stdout, :debug)
    begin
      DataMapper.setup(:default, config.database)
    rescue LoadError => e
      puts 'Please configure your database in conf/config.yml (%s)' % e.message
      exit(1)
    end
    DataMapper.finalize
    DataMapper.auto_upgrade!
    db_seed
  end

end

DeltaControl.db_init
