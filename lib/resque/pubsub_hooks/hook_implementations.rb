module Resque::Plugins::PubsubHooks
  module HookImplementations
    class Worker
      def self.before_first_fork; end
      def self.before_fork(job); end
      def self.after_fork(job); end
      def self.before_pause(worker); end
      def self.after_pause(worker); end
    end

    module Job
      def before_enqueue__with_pubsub(*args); end
      def after_enqueue__with_pubsub(*args); end
      def before_dequeue__with_pubsub(*args); end
      def after_dequeue__with_pubsub(*args); end
      def before_perform__with_pubsub(*args); end
      def after_perform__with_pubsub(*args); end
      def on_failure__with_pubsub(e, *args); end
    end
  end
end
