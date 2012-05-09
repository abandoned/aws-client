shared_examples 'a request' do
  before do
    described_class.any_instance.
      stub(:endpoint).
      and_return double.as_null_object
  end

  describe '#configure' do
    it 'configures the endpoint' do
      req = described_class.new 'US'
      req.should_receive :endpoint

      req.configure {}
    end
  end

  describe '#connection' do
    it 'builds a connection' do
      AWS::Connection.should_receive :build
      described_class.new('US').connection
    end

    it 'yields a connection builder' do
      req = described_class.new 'US'
      klass = Class.new Faraday::Middleware
      req.connection do |builder|
        builder.use klass
      end

      req.connection.builder.handlers.should include klass
    end
  end

  describe '#query' do
    subject { described_class.new('US').query }

    it 'includes a key' do
      should { include 'AWSAccessKeyId' }
    end

    it 'includes a timestamp' do
      should { include 'Timestamp' }
    end
  end

  context 'given a stubbed URI' do
    before do
      described_class.any_instance.
      stub(:uri).
      and_return URI.parse 'http://example.com/path?q=foo'

    end

    describe '#get' do
      it 'returns a response' do
        req = described_class.new 'US'

        stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('/') { [200, {}, 'foo'] }
        end

        req.connection do |builder|
          builder.adapter :test, stubs
        end

        resp = req.get
        resp.class.ancestors.map(&:to_s).should include 'AWS::Response'
      end
    end
  end
end
