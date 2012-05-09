require 'spec_helper'

module AWS
  describe Signature do
    describe '#build' do
      it 'encodes a digest' do
        sig = described_class.new 'secret'
        sig.should_receive(:digest).and_return 'foo'
        Base64.should_receive(:encode64).with('foo').and_return 'bar'
        sig.build 'message'
      end
    end

    describe '#digest' do
      it 'generates an HMAC' do
        sig = described_class.new 'secret'
        OpenSSL::HMAC.should_receive :digest
        sig.digest 'message'
      end
    end
  end
end
