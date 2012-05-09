require 'spec_helper'

module AWS
  describe Request do
    it_behaves_like 'a request'

    context 'when subclassed' do
      describe '#endpoint' do
        it 'returns the subclassed endpoint' do
          ::Foo = Module.new
          Foo.const_set :Endpoint, Class.new(AWS::Endpoint)
          Foo.const_set :Request, Class.new(AWS::Request)
          req = Foo::Request.new 'US'
          req.endpoint.class.should eq Foo::Endpoint
        end
      end
    end
  end
end
