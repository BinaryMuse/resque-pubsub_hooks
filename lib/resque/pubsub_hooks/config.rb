require 'ostruct'

module Resque::Plugins::PubsubHooks
  @configuration = OpenStruct.new(channel_name: nil)

  def self.configure
    yield @configuration
  end
end
