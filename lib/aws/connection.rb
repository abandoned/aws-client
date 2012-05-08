# External dependency.
require 'faraday'

# Internal dependencies.
require 'aws/middleware/sign_request'
require 'aws/user_agent'

module AWS
  # Internal: Builds a Faraday Connection.
  class Connection
    SIGNATURE  = Middleware::SignRequest
    USER_AGENT = UserAgent.build

    def self.build(secret, &blk)
      new(secret, &blk).build
    end

    def initialize(secret, &blk)
      @secret = secret
      @conn = Faraday.new :headers => headers, &blk
    end

    def build
      sign unless signed?
      @conn
    end

    private

    def builder
      @conn.builder
    end

    def handlers
      builder.handlers
    end

    def headers
      { 'User-Agent' => USER_AGENT }
    end

    def sign
      builder.insert handlers.size - 1, SIGNATURE, @secret
    end

    def signed?
      handlers.include? SIGNATURE
    end
  end
end
