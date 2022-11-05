# frozen_string_literal: true
require "twitter"
require "dotenv"
require_relative "posters_toolbox/version"

Dotenv.load

module PostersToolbox
  class Error < StandardError
  end
  # Your code goes here...

  class App
    attr_reader :client
    def initialize
      @client =
        Twitter::REST::Client.new do |config|
          config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
          config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
          config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
          config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
        end
    end

    def client.get_all_tweets
      collect_with_max_id do |max_id|
        options = { count: 200, include_rts: true }
        options[:max_id] = max_id unless max_id.nil?
        c.user_timeline(options)
      end
    end

    private

    def collect_with_max_id(collection = [], max_id = nil, &block)
      response = yield(max_id)
      collection += response
      if response.empty?
        collection.flatten
      else
        collect_with_max_id(collection, response.last.id - 1, &block)
      end
    end
  end
end
