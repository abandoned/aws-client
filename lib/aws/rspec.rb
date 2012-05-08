%w(endpoint request response).each do |klass|
  require "aws/rspec/shared_examples/#{klass}"
end
