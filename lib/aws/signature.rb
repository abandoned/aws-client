# Standard library dependencies.
require 'base64'
require 'forwardable'
require 'openssl'

module AWS
  # Internal: A HMAC signature builder.
  class Signature
    extend Forwardable

    def_delegator :Base64, :encode64

    # Returns the SHA256 hash algorithm.
    SHA256 = OpenSSL::Digest::SHA256.new

    # Creates a new signature builder.
    #
    # secret - The Amazon Web Services secret key.
    def initialize(secret)
      @secret = secret
    end

    # Returns a Base64-encoded HMAC.
    #
    # String signature.
    def build(message)
      encode64(digest message).chomp
    end

    # Internal: Returns a String message digest.
    #
    # message - A String message.
    def digest(message)
      OpenSSL::HMAC.digest SHA256, @secret, message
    end
  end
end
