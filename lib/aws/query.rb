module AWS
  module Query
    # Internal: Builds a query string out of query values.
    #
    # query_values - A Hash of query values.
    #
    # Returns a query String.
    def self.build(query_values)
      query_values.
        sort.
        map { |k, v| "#{k}=#{ percent_encode v }" }.
        join '&'
    end

    # Internal: Percent-encodes a query component.
    #
    # component - A query component that responds to to_s.
    #
    # Returns the String encoded component.
    def self.percent_encode(component)
      component.to_s.gsub(/([^\w.~-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end
  end
end
