require 'resque/pubsub_hooks/hooks'
require 'resque'
require 'ostruct'

class MockPublisher
  def publish(channel, msg)
    puts "called with #{channel}, #{msg}"
  end
end

module Resque::Plugins::PubsubHooks
  @configuration = OpenStruct.new(channel_name: nil)

  def self.configure
    yield @configuration
  end

  def self.redis
    Resque.redis
  end

  def self.channel
    @configuration.channel_name || "#{Resque.redis.namespace}-pubsub"
  end

  def self.publish(type, msg = nil)
    full_channel = "#{channel}:#{type}"
    msg = msg || ''
    redis.publish full_channel, msg
  end
end
