# Standard library dependencies.
require 'forwardable'
require 'time'
require 'uri'

# Internal dependencies.
require 'aws/connection'
require 'aws/endpoint'
require 'aws/query'
require 'aws/response'

module AWS
  # An Amazon Web Services (AWS) request.
  class Request
    extend Forwardable

    # Delegate clear and update to a Hash that stores the parameters for the
    # current request.
    def_delegators :@params, :clear, :update

    # Creates a new request for given locale and credentials.
    #
    # Yields the AWS Endpoint if a block is given.
    def initialize(&blk)
      @params = {}
      configure &blk if block_given?
    end

    # Yields the AWS Endpoint.
    #
    # Returns nothing.
    def configure(&blk)
      @connection = nil
      yield endpoint
    end

    # Returns a Faraday Connection.
    #
    # Yields the Faraday Builder to configure the connection if a block is
    # given.
    def connection(&blk)
      @connection ||= Connection.build endpoint.secret, &blk
    end

    # Internal: Returns a Hash of parameters that should be available in all
    # AWS requests.
    def default_params
      {
        'AWSAccessKeyId' => endpoint.key,
        'Timestamp'      => Time.now.utc.iso8601
      }
    end

    # Raises a Not Implemented Error.
    #
    # When implemented, this should return the AWS Endpoint.
    def endpoint
      raise NotImplementedError
    end

    # Gets an AWS resource.
    #
    # Returns an AWS Response.
    def get
      Response.new connection.get do |req|
        req.url uri
      end
    end

    # Posts data to an AWS resource.
    #
    # Raises a Not Implemented Error.
    def post(data)
      raise NotImplementedError
    end

    # Returns the Hash parameters of the AWS request.
    def params
      default_params.merge @params
    end

    # Returns a URI that identifies the requested AWS resource.
    def uri
      URI.new :scheme => scheme,
              :host   => host,
              :path   => path,
              :query  => query
    end

    private

    def host
      raise NotImplementedError
    end

    def path
      raise NotImplementedError
    end

    def query
      Query.build params
    end

    def scheme
      raise NotImplementedError
    end
  end
end
