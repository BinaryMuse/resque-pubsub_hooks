resque-pubsub-hooks
===================

resque-pubsub-hooks adds Redis pub/sub hooks to your Resque jobs and workers. This can be used for realtime monitoring of your Resque environment.

Resque Compatability
--------------------

resque-pubsub-hooks works with Resque 1.x, and is tested against Resque 1.24. It has not been tested against Resque 2.0 (currently at a prerelease version).

Installation
------------

Add this line to your application's Gemfile:

    gem 'resque-pubsub-hooks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resque-pubsub-hooks

Usage
-----

### Including the Hooks

resque-pubsub-hooks provides the `Resque::Plugins::Pubsub::Hooks` module, which you can mix in to your own Resque jobs.

    class Archive
      extend Resque::Plugins::Pubsub::Hooks

      @queue = :file_serve

      def self.perform(repo_id, branch = 'master')
        # ...
      end
    end

If you have multiple job types, you can create a base class and extend it for all job types.

    class JobWithPubsub
      extend Resque::Plugins::Pubsub::Hooks
    end

    class Archive < JobWithPubsub
      @queue = :file_serve

      def self.perform(repo_id, branch = 'master')
        # ...
      end
    end

### Configuring the Pub/Sub Hooks

By default, resque-pubsub-hooks will publish its events on a channel name based on the value of `Resque.redis.namespace`. For example, if the namespace is set to the default value of `resque` the gem will publish events to a channel named `resque-pubsub`.

Since the channel name is based on the Redis namespace, changing the namespace will automatically change the channel name. However, if you wish to specify the name of a channel to use, you can do so:

    Resque::Plugins::Pubsub.configure do |config|
      config.channel_name = 'my_resque_events'
    end

PubSub Events
-------------

When mixed into a module or class that Resque calls `self.perform` on, resque-pubsub-hooks will publish events on the pub/sub channel name (see above) corresponding to the available Resque hooks.

### Worker Events

  * `worker:before_first_fork` - fired before the first worker forks, triggered by `Resque.before_first_fork`
  * `worker:before_fork` - fired before a worker forks to process a job; includes the job arguments, triggered by `Resque.before_fork`
  * `worker:after_fork` - fired after a worker forks to process a job; includes the job arguments, triggered by `Resque.after_fork`
  * `worker:before_pause` - fired before a worker pauses, triggered by `Resque.before_pause`
  * `worker:after_pause` - fired after a worker pauses, triggered by `Resque.after_pause`

#### Job Events

  * `job:before_enqueue`
  * `job:after_enqueue`
  * `job:before_dequeue`
  * `job:after_dequeue`
  * `job:before_perform`
  * `job:after_perform`
  * `job:failure`
