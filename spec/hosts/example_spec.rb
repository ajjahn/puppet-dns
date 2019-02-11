require 'spec_helper'

describe 'testhost.example.com' do
  let :facts do
    {
      osfamily: 'RedHat',
      concat_basedir: '/dne',
      define_fact: '',
    }
  end

  context 'When given connected records that depend on each other' do
    it { is_expected.to compile }
  end
end
