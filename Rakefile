require 'resque/tasks'
require 'resque_scheduler/tasks'
require 'yaml'

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'


    Resque.redis = 'localhost:6379'
    Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), 'conf', 'resque_schedule.yml'))

    require_relative './lib/jobs'

  end
end
