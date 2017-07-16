require 'spec_helper'

describe 'dns::record::ptr::by_ip', :type => :define do
  let(:title) { '192.0.2.15' }
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'passing a valid host and zone' do
    let :params do {
        :host      => 'test1',
        :zone      => 'example.com',
    } end
    it { should_not raise_error }
    it { should contain_dns__record__ptr('15.2.0.192.IN-ADDR.ARPA').with({
      'host' => '15',
      'zone' => '2.0.192.IN-ADDR.ARPA',
      'data' => 'test1.example.com',
    }) }
  end

  context 'passing a valid host and empty zone' do
    let :params do {
        :host      => 'test2.example.com',
        :zone      => '',
    } end
    it { should_not raise_error }
    it { should contain_dns__record__ptr('15.2.0.192.IN-ADDR.ARPA').with({
      'host' => '15',
      'zone' => '2.0.192.IN-ADDR.ARPA',
      'data' => 'test2.example.com',
    }) }
  end

  context 'passing a valid host but not passing a zone' do
    let :params do {
        :host      => 'test3.example.com',
    } end
    it { should_not raise_error }
    it { should contain_dns__record__ptr('15.2.0.192.IN-ADDR.ARPA').with({
      'host' => '15',
      'zone' => '2.0.192.IN-ADDR.ARPA',
      'data' => 'test3.example.com',
    }) }
  end

  context 'passing a host of `@` and a valid zone' do
    let :params do {
        :host      => '@',
        :zone      => 'example.com',
    } end
    it { should_not raise_error }
    it { should contain_dns__record__ptr('15.2.0.192.IN-ADDR.ARPA').with({
      'host' => '15',
      'zone' => '2.0.192.IN-ADDR.ARPA',
      'data' => 'example.com',
    }) }
  end

  context 'passing a host of `@` and an empty zone' do
    let :params do {
        :host      => '@',
        :zone      => '',
    } end
    it { should_not raise_error }
    it { should contain_dns__record__ptr('15.2.0.192.IN-ADDR.ARPA').with({
      'host' => '15',
      'zone' => '2.0.192.IN-ADDR.ARPA',
      'data' => '@',
    }) }
  end

  context 'passing a host of `@` but not passing a zone' do
    let :params do {
        :host      => '@',
    } end
    it { should_not raise_error }
    it { should contain_dns__record__ptr('15.2.0.192.IN-ADDR.ARPA').with({
      'host' => '15',
      'zone' => '2.0.192.IN-ADDR.ARPA',
      'data' => '@',
    }) }
  end

end

