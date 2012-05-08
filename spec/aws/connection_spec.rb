require 'spec_helper'

module AWS
  describe Connection do
    subject { Connection.build 'secret', &blk }

    context 'not given any block' do
      let(:blk) { nil }

      it 'returns a connection' do
        subject.should be_a Faraday::Connection
      end

      it 'adds a User Agent header' do
        subject.headers.should have_key 'User-Agent'
      end

      it 'adds middleware that signs requests' do
        subject.builder.handlers.should include Middleware::SignRequest
      end
    end

    context 'given a block that adds middleware that signs requests' do
      let(:blk) do
        Proc.new do |builder|
          builder.use AWS::Middleware::SignRequest, 'secret'
        end
      end

      it 'does not duplicate middleware that signs requests' do
        handlers = subject.builder.handlers
        handlers.select { |h| h == Middleware::SignRequest}.count.should eq 1
      end
    end
  end
end
