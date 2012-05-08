require 'spec_helper'

module AWS
  describe Signature do
    subject { described_class.new 'secret' }

    describe '#build' do
      it 'encodes a digest' do
        subject.should_receive(:digest).and_return 'foo'
        subject.should_receive(:encode64).with('foo').and_return 'bar'
        subject.build 'message'
      end
    end

    describe '#digest' do
      after { subject.digest 'message' }

      it 'generates an HMAC' do
        OpenSSL::HMAC.should_receive :digest
      end
    end

    describe '#encode' do
      it 'base64-encodes' do
        Base64.should_receive :encode64
        subject.encode64 'message'
      end
    end
  end
end
