shared_examples 'a request' do
  subject { described_class.new }

  describe '#configure' do
    it 'configures the endpoint' do
      subject.should_receive :endpoint
      subject.configure {}
    end
  end

  context 'given a stubbed endpoint' do
    before do
      begin
        described_class.new.endpoint
      rescue NotImplementedError
        described_class.any_instance.
          stub(:endpoint).
          and_return double.as_null_object
      end
    end

    describe 'clear' do
      it 'removes user-defined parameters from the request' do
        subject.update 'Key' => 'value'
        subject.clear

        subject.params.should_not have_key 'Key'
      end
    end

    describe '#connection' do
      it 'builds a connection' do
        AWS::Connection.should_receive :build
        subject.connection
      end

      it 'yields a builder' do
        klass = Class.new Faraday::Middleware
        subject.connection do |builder|
          builder.use klass
        end

        subject.connection.builder.handlers.should include klass
      end
    end

    describe '#default_params' do
      subject { described_class.new.default_params }

      it 'includes a key' do
        should { include 'AWSAccessKeyId' }
      end

      it 'includes a timestamp' do
        should { include 'Timestamp' }
      end
    end

    describe '#params' do
      it 'includes the default parameters' do
        subject.params.merge(subject.default_params).should eq subject.params
      end
    end

    describe '#update' do
      it 'adds key-value pairs to the parameters of the request' do
        subject.update 'Key' => 'value'
        subject.params['Key'].should eq 'value'
      end
    end

    context 'given a stubbed URI' do
      before do
        described_class.any_instance.
        stub(:uri).
        and_return URI.parse 'http://example.com/path?q=foo'

        stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('/') { [200, {}, 'foo'] }
        end

        subject.connection do |builder|
          builder.adapter :test, stubs
        end
      end

      describe '#get' do
        it 'returns a response' do
          resp = subject.get
          resp.class.ancestors.map(&:to_s).should include 'AWS::Response'
        end
      end
    end
  end
end
