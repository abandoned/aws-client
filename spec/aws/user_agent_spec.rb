require 'spec_helper'

module AWS
  describe UserAgent do
    describe '.build' do
      subject { UserAgent.build }

      it 'describes the library' do
        should { match /AWS::Client\/[\d\w.]+\s/ }
      end

      it 'describes the Ruby interpreter' do
        should { match /Language=(?:j?ruby|rbx)/ }
      end

      it 'describes the host' do
        should { match /Host=[\w\d]+/ }
      end
    end
  end
end
