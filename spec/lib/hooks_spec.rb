require 'spec_helper'

describe 'Resque::Plugins::PubsubHooks::Hooks' do
  it 'should install global Resque hooks' do
    klass = Class.new
    Resque.should_receive(:before_first_fork)
    Resque.should_receive(:before_fork)
    Resque.should_receive(:after_fork)
    Resque.should_receive(:before_pause)
    Resque.should_receive(:after_pause)
    klass.send(:include, Resque::Plugins::PubsubHooks::Hooks)
  end

  it 'should publish via Redis when forking', focus: true do
    klass = Class.new
    Resque::Plugins::PubsubHooks.redis.should_receive(:publish).with('resque-pubsub:before_first_fork', '').and_call_original
    # TODO: find out why these hooks aren't getting called
    # Resque::Plugins::PubsubHooks.redis.should_receive(:publish).with('resque-pubsub:before_fork', 'test').and_call_original
    # Resque::Plugins::PubsubHooks.redis.should_receive(:publish).with('resque-pubsub:after_fork', 'test').and_call_original
    klass.send(:include, Resque::Plugins::PubsubHooks::Hooks)
    perform_job_with_fork(FakeClass, 1, 2, 3)
  end

  class FakeClass
    @queue = :test
    include Resque::Plugins::PubsubHooks::Hooks
    def self.perform(*args)
      puts "in perform #{args.inspect}"
    end
  end

  it 'fires lifecycle hooks while processing a job' do
    # TODO: should be before_enqueue__with_pubsub etc.
    # TODO: should spec that it receives correct args
    FakeClass.should_receive(:before_enqueue).with(1, 2, 3)
    FakeClass.should_receive(:after_enqueue).with(1, 2, 3)
    FakeClass.should_receive(:before_perform).with(1, 2, 3)
    FakeClass.should_receive(:after_perform).with(1, 2, 3)
    perform_job(FakeClass, 1, 2, 3)
  end

  it 'fires lifecycle hooks while dequeueing a job' do
    FakeClass.should_receive(:before_dequeue).with()
    FakeClass.should_receive(:after_dequeue).with()
    Resque.enqueue(FakeClass, 1, 2, 3)
    Resque.dequeue(FakeClass)
  end
end
