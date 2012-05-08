require 'aws/client/version'

module AWS
  # Internal: Builds a User Agent.
  module UserAgent
    class << self
      def build
        "AWS::Client/#{version} (Language=#{language}; Host=#{hostname})"
      end

      def engine
        defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
      end

      def hostname
        `hostname`.chomp
      end

      def language
        [engine, RUBY_VERSION, "p#{RUBY_PATCHLEVEL}"].join ' '
      end

      def version
        AWS::Client::VERSION
      end
    end
  end
end
