shared_examples 'a response' do
  context 'given an instance' do
    let(:http) do
      http = double 'Faraday::Response'
      http.stub!(:body).and_return \
        '<?xml version="1.0" ?>
          <children>
            <child>
              <name>foo</name>
            </child>
            <child>
              <name>bar</name>
            </child>
          </children>'.gsub />\s+</, '><'
      http.stub!(:status).and_return 200

      http
    end

    subject do
      described_class.new http
    end

    let(:child) { subject.xml.children.first.name }

    describe '#find' do
      it 'returns an Array of matches' do
        subject.find(child).should_not be_empty
      end

      it 'yields matches to a block' do
        yielded = false
        subject.find(child) { yielded = true }
        yielded.should be_true
      end

      it 'is aliased to []' do
        subject.find(child).should eq subject[child]
      end
    end

    describe '#to_hash' do
      it 'casts response to a hash' do
        subject.to_hash.should be_a Hash
      end
    end

    describe '#valid?' do
      context 'when HTTP status is OK' do
        it 'returns true' do
          should { be_valid }
        end
      end

      context 'when HTTP status is not OK' do
        before do
          http.stub!(:status).and_return 403
        end

        it 'returns false' do
          should_not { be_valid }
        end
      end
    end

    describe '#xml' do
      it 'returns a Nokogiri document' do
        subject.xml.should be_an_instance_of Nokogiri::XML::Document
      end
    end
  end
end
