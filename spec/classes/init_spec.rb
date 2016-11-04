require 'spec_helper'
describe 'ekahau_throughput_server' do

  context 'with defaults for all parameters' do
    it { should contain_class('ekahau_throughput_server') }
  end
end
