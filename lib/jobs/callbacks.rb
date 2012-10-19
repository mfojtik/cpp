require 'bundler'

Bundler.setup :default
Bundler.require

require_relative '../../init'

DeltaControl.db_init(:no_logger => true, :no_seed => true)

module CallBackJob

  def self.perform
    DeltaControl::Callback.active.each { |c| Resque.enqueue(DeltaControl::Callback, c.id) }
  end

end
