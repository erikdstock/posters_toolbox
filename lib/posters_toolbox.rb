# frozen_string_literal: true
require "twitter"
require "dotenv"
require_relative "posters_toolbox/version"
require_relative "posters_toolbox/load_app"

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

    def get_all_tweets
      puts "fetching tweets:"
      collect_with_max_id do |max_id|
        options = { count: 200, include_rts: true, tweet_mode: "extended" }
        options[:max_id] = max_id unless max_id.nil?
        client.user_timeline(options)
      end
    end

    private

    def collect_with_max_id(collection = [], max_id = nil, &block)
      response = yield(max_id)
      collection += response
      if response.empty? || ENV["TEST"] == "1"
        puts "."
        collection.flatten
      else
        print(".")
        collect_with_max_id(collection, response.last.id - 1, &block)
      end
    end
  end
end

=begin

ts = a.get_all_tweets
ts.filter { |t| !(t.quote? || t.retweet? || t.reply? ) }.map do |t|
  { full_text: t.full_text, favorite_count: t.favorite_count, quote_count: t.quote_count, reply_count: t.reply_count, retweet_count: t.retweet_count }
end

=end
