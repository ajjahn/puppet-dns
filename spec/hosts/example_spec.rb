require 'spec_helper'

describe 'testhost.example.com' do

  let(:facts) {{ :osfamily => 'RedHat', :concat_basedir  => '/dne', :define_fact => "" }}

  context 'When given connected records that depend on each other' do
    it { should compile }
  end

end