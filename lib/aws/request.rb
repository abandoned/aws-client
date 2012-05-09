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

    def_delegators :@query, :clear, :update

    # Creates a new request for given locale and credentials.
    #
    # Yields the AWS Endpoint if a block is given.
    def initialize(locale, &blk)
      @locale = locale
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

    def default
      {
        'AWSAccessKeyId' => endpoint.key,
        'Timestamp'      => Time.now.utc.iso8601
      }
    end

    # Returns an AWS Endpoint.
    def endpoint
      @endpoint ||= subclass(:Endpoint).new @locale
    end

    # Gets an AWS resource.
    #
    # Returns an AWS Response.
    def get
      subclass(:Response).new connection.get do |req|
        req.url uri
      end
    end

    def host
      raise NotImplementedError
    end

    def path
      raise NotImplementedError
    end

    # Posts data to an AWS resource.
    #
    # Raises a Not Implemented Error.
    def post(data)
      raise NotImplementedError
    end

    def query
      (@query ||= Query.new default).string
    end

    def scheme
      raise NotImplementedError
    end

    # Returns a URI that identifies the requested AWS resource.
    def uri
      URI.new :scheme => scheme,
              :host   => host,
              :path   => path,
              :query  => query
    end

    private

    def nesting_module
      Object.const_get self.class.name.gsub /::[^:]+/, ''
    end

    def subclass(name)
      if nesting_module.const_defined? name
        nesting_module.const_get name
      else
        AWS.const_get name
      end
    end
  end
end
