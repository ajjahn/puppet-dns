require 'spec_helper'

describe 'dns::record::mx', :type => :define do
  let(:title) { 'mxtest' }
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'passing an implicit origin' do
    let :params do {
        :zone => 'example.com',
        :data => 'mailserver.example.com'
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.mxtest,example.com,MX,10,mailserver.example.com.record').with_content(/^@\s+IN\s+MX\s+10\s+mailserver\.example\.com\.$/) }
  end

  context 'passing an explicit origin and preference' do
    let :params do {
        :zone       => 'example.com',
        :data       => 'ittybittymx.example.com',
        :host       => 'branchoffice',
        :preference => 22
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.mxtest,example.com,MX,22,ittybittymx.example.com.record').with_content(/^branchoffice\s+IN\s+MX\s+22\s+ittybittymx\.example\.com\.$/) }
  end

  context 'passing a wrong (out-of-range) preference' do
    let :params do {
        :zone       => 'example.com',
        :data       => 'badpref.example.com',
        :preference => 65537
    } end
    it { should raise_error(Puppet::Error, /must be an integer within 0-65536/) }
  end

  context 'passing a wrong (string) preference' do
    let :params do {
        :zone       => 'example.com',
        :data       => 'worsepref.example.com',
        :preference => 'highest'
    } end
    it { should raise_error(Puppet::Error, /must be an integer within 0-65536/) }
  end

  context 'passing a wrong (numeric top-level domain) zone' do
    let :params do {
        :zone => 'one.618',
        :data => 'goldenratio.example.com'
    } end
    it { should raise_error(Puppet::Error, /must be a valid domain name/) }
  end

  context 'passing a wrong (numeric) zone' do
    let :params do {
        :zone => 123,
        :data => 'badzone.example.com'
    } end
    it { should raise_error(Puppet::Error, /must be a valid domain name/) }
  end

  context 'passing a wrong (IP address) zone' do
    let :params do {
        :zone => '192.168.1.1',
        :data => 'ipaddrzone.example.com'
    } end
    it { should raise_error(Puppet::Error, /must be a valid domain name/) }
  end

  context 'passing wrong (numeric) data' do
    let :params do {
        :zone => 'example.com',
        :data => 456
    } end
    it { should raise_error(Puppet::Error, /must be a valid hostname/) }
  end

  context 'passing wrong (IP address) data' do
    let :params do {
        :zone => 'example.com',
        :data => '192.168.4.4'
    } end
    it { should raise_error(Puppet::Error, /must be a valid hostname/) }
  end

end

