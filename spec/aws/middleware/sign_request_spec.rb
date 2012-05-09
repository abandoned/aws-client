require 'spec_helper'

module AWS
  module Middleware
    describe SignRequest do
      describe '#call' do
        it 'signs the request' do
          middleware = described_class.new lambda { |env| env }, 'secret'
          res = middleware.call :url => URI('http://example.com/?q=1')
          res[:url].query.should match /&Signature=.+/
        end
      end
    end
  end
end
