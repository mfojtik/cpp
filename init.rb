require 'sinatra/base'
require 'haml'
require 'ostruct'
require 'deltacloud/api'

require_relative './lib/helpers/views_helper'
require_relative './lib/helpers/app_helper'

require_relative './lib/db/log'
require_relative './lib/db/account'
require_relative './lib/db/callback'

module DeltaControl

  def self.config
    @@config ||= OpenStruct.new(
      YAML.load(File.read(File.join(File.dirname(__FILE__), 'conf', 'config.yml')))
    )
  end

  def self.db_seed
    User.create(:name => 'admin', :password => 'redhat') unless User.first(:name => 'admin')
    User.create(:name => 'test', :password => 'redhat') unless User.first(:name => 'test')
  end

  def self.db_init(opts={})
    DataMapper::Logger.new($stdout, :debug) unless opts[:no_logger]
    begin
      DataMapper.setup(:default, config.database)
    rescue LoadError => e
      puts 'Please configure your database in conf/config.yml (%s)' % e.message
      exit(1)
    end
    DataMapper.finalize
    DataMapper.auto_upgrade!
    db_seed unless opts[:no_seed]
  end

end
