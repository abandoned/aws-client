module AWS
  # Internal: Builds a query string.
  class Query
    extend Forwardable

    def_delegators :@values, :clear, :update

    # Percent-encodes a query component.
    #
    # val - A query component that responds to to_s.
    #
    # Returns a String query component.
    def self.encode(val)
      val.to_s.gsub(/([^\w.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    def initialize(default = {})
      @default, @values = default, {}
    end

    # Returns the String query string.
    def string
      values.sort.map { |k, v| "#{k}=#{ Query.encode v }" }.join '&'
    end

    # Returns the Hash query values.
    def values
      @default.merge @values
    end
  end
end
