require 'resque/pubsub_hooks/hooks'
require 'resque'
require 'ostruct'

class MockPublisher
  def publish(channel, msg)
    puts "called with #{channel}, #{msg}"
  end
end

module Resque::Plugins::PubsubHooks
  @configuration = OpenStruct.new(channel_prefix: nil)

  def self.configure
    yield @configuration
  end

  def self.redis
    Resque.redis
  end

  def self.channel_prefix
    @configuration.channel_prefix || "#{Resque.redis.namespace}-pubsub"
  end

  def self.publish(event, msg = nil)
    channel = "#{channel_prefix}:#{event}"
    msg = msg || ''
    redis.publish channel, msg
  end
end
