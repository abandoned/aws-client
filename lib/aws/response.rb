# Standard library dependency.
require 'forwardable'

# External dependency.
require 'nokogiri'

# Internal dependency.
require 'aws/xml_utils'

module AWS
  # A wrapper around an Amazon Web Services (AWS) response.
  class Response
    extend Forwardable

    # Delegate body and status to the Faraday Response.
    def_delegators :@http, :body, :status

    # Creates a new Response.
    #
    # http - A Faraday Response.
    def initialize(http)
      @http = http
    end

    # Queries the response.
    #
    # query - String attribute to be queried.
    #
    # Yields matching nodes to a given block if one is given.
    #
    # Returns an Array of matching nodes or the return values of the yielded
    # block if latter was given.
    def find(query)
      path = if xml.namespaces.empty?
               "//#{query}"
             else
               "//xmlns:#{query}"
             end

      xml.xpath(path).map do |node|
        hsh = XMLUtils.to_hash node
        block_given? ? yield(hsh) : hsh
      end
    end

    alias [] find

    # Returns a Hash representation of the response.
    def to_hash
      XMLUtils.to_hash xml
    end

    # Returns whether the HTTP response is OK.
    def valid?
      status == 200
    end

    # Returns an XML document.
    def xml
      @xml ||= Nokogiri::XML.parse body
    end
  end
end
