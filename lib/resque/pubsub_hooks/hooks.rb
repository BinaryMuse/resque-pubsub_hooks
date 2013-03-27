require 'resque'
require 'redis'
require 'resque/pubsub_hooks/hook_implementations'

module Resque::Plugins::PubsubHooks
  module Hooks
    @already_included = false

    def self.included(base)
      puts "* including Hooks into #{base.name}"
      base.send(:extend, Resque::Plugins::PubsubHooks::HookImplementations::Job)

      puts "* Hooks.included: already_included = #{@already_included}"
      unless @already_included
        @already_included = true
        worker_impls = Resque::Plugins::PubsubHooks::HookImplementations::Worker
        [:before_first_fork, :before_fork, :after_fork, :before_pause, :after_pause].each do |meth|
          Resque.send(meth, &worker_impls.method(meth))
        end
      end
    end
  end
end
