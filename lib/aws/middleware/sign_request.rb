# Standard library dependency.
require 'uri'

# External dependency.
require 'faraday'

# Internal dependencies.
require 'aws/query'
require 'aws/signature'

module AWS
  module Middleware
    # Internal: A Faraday middleware that signs requests to Amazon Web
    # Services.
    class SignRequest < Faraday::Middleware
      # Initializes the middleware.
      #
      # app    - An Object that responds to call and returns a Faraday
      #          Response.
      # secret - The String Amazon AWS access secret key.
      def initialize(app, secret)
        @secret = secret
        super app
      end

      # Signs the request.
      #
      # env - A Hash that contains info about the request.
      #
      # Returns an Object that responds to call and returns a Faraday Response.
      def call(env)
        signature = Query.encode sign string_to_sign env
        separator = env[:url].to_s.match(/\?.+/) ? '&' : ''
        env[:url].query = "#{env[:url].query}#{separator}Signature=#{signature}"

        @app.call env
      end

      private

      def sign(message)
        builder = Signature.new @secret
        builder.build message
      end

      def string_to_sign(env)
        [
          env[:method].to_s.upcase,
          env[:url].host,
          env[:url].path,
          env[:url].query
        ].join "\n"
      end
    end
  end
end
