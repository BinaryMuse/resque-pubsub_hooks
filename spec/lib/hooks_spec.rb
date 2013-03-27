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

  class FakeClass
    @queue = :test
    include Resque::Plugins::PubsubHooks::Hooks
    def self.perform(*args)
      puts "in perform #{args.inspect}"
    end
  end

  it 'fires lifecycle hooks while processing a job' do
    FakeClass.should_receive(:before_enqueue).with(1, 2, 3)
    FakeClass.should_receive(:after_enqueue).with(1, 2, 3)
    FakeClass.should_receive(:before_perform).with(1, 2, 3)
    FakeClass.should_receive(:after_perform).with(1, 2, 3)
    perform_job(FakeClass, 1, 2, 3)
  end
end
