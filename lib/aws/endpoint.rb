module AWS
  BadLocale     = Class.new ArgumentError
  MissingKey    = Class.new ArgumentError
  MissingSecret = Class.new ArgumentError

  # An Amazon Web Services (AWS) endpoint.
  class Endpoint
    # Available AWS locales.
    LOCALES = %w(CA CN DE ES FR IT JP UK US)

    # Returns the String AWS access key Id.
    #
    # Raises a Missing Key error if key is missing.
    def key
      @key or raise MissingKey
    end

    # Sets the String AWS access key Id.
    #
    # Returns nothing.
    attr_writer :key

    # Returns the String AWS locale.
    #
    # Raises a Bad Locale error if locale is not valid.
    def locale
      LOCALES.include? @locale or raise BadLocale
      @locale
    end

    # Sets the String AWS locale.
    #
    # Returns nothing.
    attr_writer :locale

    # Returns the String AWS access secret key.
    #
    # Raises a Missing Secret error if secret is missing.
    def secret
      @secret or raise MissingSecret
    end

    # Sets the String AWS access secret key.
    #
    # Returns nothing.
    attr_writer :secret

    # Gets/Sets the String AWS session token.
    attr_accessor :session
  end
end
