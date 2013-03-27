require 'resque/pubsub_hooks'

RSpec.configure do |config|
  config.before(:suite) do
    dir = File.expand_path File.dirname(__FILE__)
    system "redis-server #{dir}/redis.conf > /tmp/redis.log 2>&1 || cat /tmp/redis.log"
    Resque.redis = Redis.new(port: 9735)
    until Resque.redis.client.connected?
      begin
        Resque.redis.client.connect
      rescue Redis::CannotConnectError
      end
    end
  end

  config.before(:each) do
    [:before_first_fork, :before_fork, :after_fork, :before_pause, :after_pause].each do |meth|
      Resque.send(:clear_hooks, meth)
    end
    Resque::Plugins::PubsubHooks::Hooks.instance_variable_set('@already_included', false)
  end
end

at_exit do
  system "redis-cli -p 9735 flushdb > /tmp/redis-cli.log 2>&1 || cat /tmp/redis-cli.log"
  system "redis-cli -p 9735 shutdown nosave > /tmp/redis-cli.log 2>&1 || cat /tmp/redis-cli.log"
end

def perform_job(klass, *args)
  Resque.redis.flushall
  Resque.enqueue(klass, *args)

  worker = Resque::Worker.new(:test)
  unless job = worker.reserve
    raise "could not reserve a resque job on queue 'test'; check your queue configuration"
  end
  worker.perform(job)
  worker.done_working
end
