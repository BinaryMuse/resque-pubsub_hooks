require 'resque'

module Resque::Plugins::PubsubHooks
  module HookImplementations
    class Worker
      def self.before_first_fork
        Resque::Plugins::PubsubHooks.publish 'before_first_fork'
      end

      def self.before_fork(job)
        Resque::Plugins::PubsubHooks.publish 'before_fork', JSON.generate(queue: job.queue, payload: job.payload)
      end

      def self.after_fork(job)
        Resque::Plugins::PubsubHooks.publish 'after_fork', JSON.generate(queue: job.queue, payload: job.payload)
      end
    end

    module Job
      def before_enqueue__with_pubsub(*args)
        Resque::Plugins::PubsubHooks.publish 'before_enqueue'
      end

      def after_enqueue__with_pubsub(*args)
        Resque::Plugins::PubsubHooks.publish 'after_enqueue'
      end

      def before_dequeue__with_pubsub(*args)
        Resque::Plugins::PubsubHooks.publish 'before_dequeue'
      end

      def after_dequeue__with_pubsub(*args)
        Resque::Plugins::PubsubHooks.publish 'after_dequeue'
      end

      def before_perform__with_pubsub(*args)
        Resque::Plugins::PubsubHooks.publish 'before_perform'
      end

      def after_perform__with_pubsub(*args)
        Resque::Plugins::PubsubHooks.publish 'after_perform'
      end

      def on_failure__with_pubsub(e, *args)
        Resque::Plugins::PubsubHooks.publish 'on_failure'
      end
    end
  end
end
