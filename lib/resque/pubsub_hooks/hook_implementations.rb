require 'resque'

module Resque::Plugins::PubsubHooks
  module HookImplementations
    class Worker
      def self.before_first_fork
        Resque::Plugins::PubsubHooks.publish 'before_first_fork'
      end
      def self.before_fork(job)
        Resque::Plugins::PubsubHooks.publish 'before_fork', 'test'
      end
      def self.after_fork(job)
        Resque::Plugins::PubsubHooks.publish 'after_fork', 'test'
      end
      def self.before_pause(worker)
        # puts "* before_pause"
      end
      def self.after_pause(worker)
        # puts "* after_pause"
      end
    end

    module Job
      def before_enqueue__with_pubsub(*args)
        # puts "* before_enqueue__with_pubsub(#{args.inspect})"
      end
      def after_enqueue__with_pubsub(*args)
        # puts "* after_enqueue__with_pubsub(#{args.inspect})"
      end
      def before_dequeue__with_pubsub(*args)
        # puts "* before_dequeue__with_pubsub(#{args.inspect})"
      end
      def after_dequeue__with_pubsub(*args)
        # puts "* after_dequeue__with_pubsub(#{args.inspect})"
      end
      def before_perform__with_pubsub(*args)
        # puts "* before_perform__with_pubsub(#{args.inspect})"
      end
      def after_perform__with_pubsub(*args)
        # puts "* after_perform__with_pubsub(#{args.inspect})"
      end
      def on_failure__with_pubsub(e, *args)
        # puts "* on_failure__with_pubsub(#{e.inspect}, #{args.inspect})"
      end
    end
  end
end
