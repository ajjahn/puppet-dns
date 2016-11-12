require 'spec_helper'

describe 'dns::tsig' do
  let(:facts) {{ :osfamily => 'Debian', :concat_basedir => '/mock_dir' }}
  let(:title) { 'ns3' }
  let :pre_condition do
    'class { "::dns::server::config": }'
  end

  context 'passing valid array to server' do
    let :params do
      { :server => [ '192.168.0.1', '192.168.0.2' ],
        :algorithm => 'hmac-md5',
        :secret => 'La/E5CjG9O+os1jq0a2jdA==' }
    end
    it { should_not raise_error }
    it { should contain_concat__fragment('named.conf.local.tsig.ns3.include') }
    it { should contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(/key ns3\. \{/)  }
    it { should contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(/server 192\.168\.0\.1/)  }
    it { should contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(/server 192\.168\.0\.2/)  }
  end

  context 'passing valid string to server' do
    let :params do
      { :server => '192.168.0.1', 
        :algorithm => 'hmac-md5',
        :secret => 'La/E5CjG9O+os1jq0a2jdA==' }
    end
    it { should_not raise_error }

    it { should contain_concat__fragment('named.conf.local.tsig.ns3.include') }
    it { should contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(/key ns3\. \{/)  }
    it { should contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(/server 192\.168\.0\.1/)  }
  end

end

