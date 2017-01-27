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
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.42.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record') }
  end

  context 'passing a single ip address with ptr=>first' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => '192.168.128.42',
        :ptr => 'first',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.42$/) }
    it { should contain_notify("PTR record for IP address '192.168.128.42' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
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
    it { should contain_notify("PTR record for IP address '192.168.128.42' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
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
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record') }
  end

  context 'passing multiple ip addresses with ptr=>first' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(/^atest\s+IN\s+A\s+192\.168\.128\.68\natest\s+IN\s+A\s+192\.168\.128\.69\natest\s+IN\s+A\s+192\.168\.128\.70$/) }
    it { should contain_notify("PTR record for IP address '192.168.128.68' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
    it { should_not contain_notify("PTR record for IP address '192.168.128.69' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
    it { should_not contain_notify("PTR record for IP address '192.168.128.70' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
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
    it { should contain_notify("PTR record for IP address '192.168.128.68' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
    it { should contain_notify("PTR record for IP address '192.168.128.69' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
    it { should contain_notify("PTR record for IP address '192.168.128.70' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.")}
  end

  context 'passing ptr=>first with class A network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,192.in-addr.arpa.record').with_content(/^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,192.in-addr.arpa.record').with_content(/^69\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,192.in-addr.arpa.record').with_content(/^70\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class B network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,192.in-addr.arpa.record').with_content(/^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,192.in-addr.arpa.record').with_content(/^69\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,192.in-addr.arpa.record').with_content(/^70\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class B network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A and class B network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A and class B network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,168.192.in-addr.arpa.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A and class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A and class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class B and class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "168.192.in-addr.arpa": }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class B and class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "168.192.in-addr.arpa": }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A, class B and class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "168.192.in-addr.arpa": }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A, class B and class C network defined with parameter reverse is false (default)' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "168.192.in-addr.arpa": }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.68.128.168.192,PTR,192.record').with_content(/^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.69.128.168.192,PTR,192.record').with_content(/^69\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.70.128.168.192,PTR,192.record').with_content(/^70\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class B network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.68.128.168.192,PTR,168.192.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.69.128.168.192,PTR,168.192.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.70.128.168.192,PTR,168.192.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.68.128.168.192,PTR,192.record').with_content(/^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.69.128.168.192,PTR,192.record').with_content(/^69\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.70.128.168.192,PTR,192.record').with_content(/^70\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class B network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.68.128.168.192,PTR,168.192.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.69.128.168.192,PTR,168.192.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.70.128.168.192,PTR,168.192.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A and class B network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.68.128.168.192,PTR,168.192.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.69.128.168.192,PTR,168.192.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.168.192.70.128.168.192,PTR,168.192.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A and class B network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.168.192.68.128.168.192,PTR,168.192.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.69.128.168.192,PTR,168.192.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.168.192.70.128.168.192,PTR,168.192.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A and class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A and class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class B and class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "168.192": reverse => true, }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class B and class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "168.192": reverse => true, }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A, class B and class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "168.192": reverse => true, }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A, class B and class C network defined with parameter reverse is true' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "168.192": reverse => true, }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.68.128.168.192,PTR,192.record').with_content(/^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.69.128.168.192,PTR,192.record').with_content(/^69\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.70.128.168.192,PTR,192.record').with_content(/^70\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class B network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.168": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.68.128.192.168,PTR,192.168.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.69.128.192.168,PTR,192.168.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.70.128.192.168,PTR,192.168.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.68.128.168.192,PTR,192.record').with_content(/^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.69.128.168.192,PTR,192.record').with_content(/^69\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.70.128.168.192,PTR,192.record').with_content(/^70\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class B network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.168": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.68.128.192.168,PTR,192.168.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.69.128.192.168,PTR,192.168.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.70.128.192.168,PTR,192.168.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A and class B network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "192.168": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.68.128.192.168,PTR,192.168.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.69.128.192.168,PTR,192.168.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.70.128.192.168,PTR,192.168.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A and class B network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "192.168": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.68.128.192.168,PTR,192.168.record').with_content(/^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.69.128.192.168,PTR,192.168.record').with_content(/^69\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.70.128.192.168,PTR,192.168.record').with_content(/^70\.128\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A and class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A and class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class B and class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.168": reverse => "reverse", }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class B and class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.168": reverse => "reverse", }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A, class B and class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "192.168": reverse => "reverse", }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A, class B and class C network defined with parameter reverse is "reverse"' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "192.168": reverse => "reverse", }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A (defined with parameter reverse is false), class B (defined with parameter reverse is true) and class C (defined with parameter reverse is "reverse") network' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "168.192": reverse => true, }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A (defined with parameter reverse is false), class B (defined with parameter reverse is true) and class C (defined with parameter reverse is "reverse") network' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192.in-addr.arpa": }',
        'dns::zone { "168.192": reverse => true, }',
        'dns::zone { "192.168.128": reverse => "reverse", }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.192.168.128.68.192.168.128,PTR,192.168.128.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.69.192.168.128,PTR,192.168.128.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.192.168.128.70.192.168.128,PTR,192.168.128.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A (defined with parameter reverse is "reverse"), class B (defined with parameter reverse is false) and class C (defined with parameter reverse is true) network' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "168.192.in-addr.arpa": }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A (defined with parameter reverse is "reverse"), class B (defined with parameter reverse is false) and class C (defined with parameter reverse is true) network' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => "reverse", }',
        'dns::zone { "168.192.in-addr.arpa": }',
        'dns::zone { "128.168.192": reverse => true, }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.68.128.168.192,PTR,128.168.192.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.69.128.168.192,PTR,128.168.192.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.70.128.168.192,PTR,128.168.192.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>first with class A (defined with parameter reverse is true), class B (defined with parameter reverse is "reverse") and class C (defined with parameter reverse is false) network' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'first',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "192.168": reverse => "reverse", }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should_not contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

  context 'passing ptr=>all with class A (defined with parameter reverse is true), class B (defined with parameter reverse is "reverse") and class C (defined with parameter reverse is false) network' do
    let :params do {
        :host => 'atest',
        :zone => 'example.com',
        :data => [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ],
        :ptr => 'all',
    } end
    let :pre_condition do [
        'dns::zone { "192": reverse => true, }',
        'dns::zone { "192.168": reverse => "reverse", }',
        'dns::zone { "128.168.192.in-addr.arpa": }',
    ] end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.68.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^68\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.69.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^69\s+IN\s+PTR\s+atest\.example\.com\.$/) }
    it { should contain_concat__fragment('db.128.168.192.in-addr.arpa.70.128.168.192.in-addr.arpa,PTR,128.168.192.in-addr.arpa.record').with_content(/^70\s+IN\s+PTR\s+atest\.example\.com\.$/) }
  end

end
