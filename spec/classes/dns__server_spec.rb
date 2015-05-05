require 'spec_helper'

describe 'dns::server' do

  context "By Default" do
    let(:facts) {{ :osfamily => 'Debian', :concat_basedir  => '/dne' }}
    it { should contain_class('dns::server::install') }
    it { should contain_class('dns::server::config') }
    it { should contain_class('dns::server::service') }
  end

end
