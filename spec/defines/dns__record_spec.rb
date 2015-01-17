require 'spec_helper'

describe 'dns::record', :type => :define do
  let(:title) { 'recordtest' }
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'passing a LOC record' do
    let :params do {
        :zone      => 'example.com',
        :host      => 'saturnv',
        :dns_class => 'IN',
        :record    => 'LOC',
        :data      => '34 42 40.126 N 86 39 21.248 W 203m 10m 100m 10m',
        :ttl       => '1h45m10s'
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.recordtest.record').with_content(/^saturnv\s+1h45m10s\s+IN\s+LOC\s+34 42 40.126 N 86 39 21.248 W 203m 10m 100m 10m$/) }
  end

  context 'passing a wrong (out-of-range) TTL' do
    let :params do {
        :zone      => 'example.com',
        :host      => 'badttl',
        :dns_class => 'IN',
        :record    => 'A',
        :data      => '172.16.104.1',
        :ttl       => 2147483648
    } end
    it { should raise_error(Puppet::Error, /must be an integer within 0-2147483647/) }
  end

  context 'passing a wrong (string) TTL' do
    let :params do {
        :zone      => 'example.com',
        :host      => 'textttl',
        :dns_class => 'IN',
        :record    => 'A',
        :data      => '172.16.104.2',
         :ttl      => '4scoreand7years'
    } end
    it { should raise_error(Puppet::Error, /explicitly specified time units/) }
  end

end

