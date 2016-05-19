require 'spec_helper'

describe 'dns::record::a', :type => :define do
  let(:title) { 'atest' }
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'passing a single ip address with ptr=>false' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => '192.168.128.42',
        :ptr => false,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.42$/) }
    it { should_not contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.42.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record') }
  end

  context 'passing a single ip address with ptr=>true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => '192.168.128.42',
        :ptr => true,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.42$/) }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.42.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^42\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing a single ip address with ptr=>all' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => '192.168.128.42',
        :ptr => 'all',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.42$/) }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.42.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^42\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing multiple ip addresses with ptr=>false' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => false,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.68\natest\s+IN\s+A\s+192\.168\.128\.69\natest\s+IN\s+A\s+192\.168\.128\.70$/) }
    it { should_not contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record') }
  end

  context 'passing multiple ip addresses with ptr=>true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => true,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.68\natest\s+IN\s+A\s+192\.168\.128\.69\natest\s+IN\s+A\s+192\.168\.128\.70$/) }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing multiple ip addresses with ptr=>all' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.68\natest\s+IN\s+A\s+192\.168\.128\.69\natest\s+IN\s+A\s+192\.168\.128\.70$/) }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.69.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.70.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>true with class A network defined' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.IN-ADDR.ARPA": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,192.IN-ADDR.ARPA.record').with_content(/^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>true with class B network defined' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "168.192.IN-ADDR.ARPA": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,168.192.IN-ADDR.ARPA.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>true with class C network defined' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "128.168.192.IN-ADDR.ARPA": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>true with class A and class B network defined' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.IN-ADDR.ARPA": }',
        'dns::zone { "168.192.IN-ADDR.ARPA": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,168.192.IN-ADDR.ARPA.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>true with class A and class C network defined' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.IN-ADDR.ARPA": }',
        'dns::zone { "128.168.192.IN-ADDR.ARPA": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>true with class B and class C network defined' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "168.192.IN-ADDR.ARPA": }',
        'dns::zone { "128.168.192.IN-ADDR.ARPA": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>true with class A, class B and class C network defined' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.IN-ADDR.ARPA": }',
        'dns::zone { "168.192.IN-ADDR.ARPA": }',
        'dns::zone { "128.168.192.IN-ADDR.ARPA": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

end

