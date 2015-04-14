require 'spec_helper'

describe 'dns::record::aaaa', :type => :define do
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'letting the host be defined by the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :data => ['::1'] ,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,AAAA,example.com.record')
      .with_content(/^foo\s+IN\s+AAAA\s+::1$/)
     }
  end

  context 'assigning a different host than the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :host => 'bar' ,
        :data => ['::1'] ,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,AAAA,example.com.record')
      .with_content(/^bar\s+IN\s+AAAA\s+::1$/)
     }
  end

end

describe 'dns::record::a', :type => :define do
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'letting the host be defined by the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :data => ['1.2.3.4'] ,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,A,example.com.record')
      .with_content(/^foo\s+IN\s+A\s+1\.2\.3\.4$/)
     }
  end

  context 'assigning a different host than the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :host => 'bar' ,
        :data => ['1.2.3.4'] ,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,A,example.com.record')
      .with_content(/^bar\s+IN\s+A\s+1\.2\.3\.4$/)
     }
  end

end

describe 'dns::record::cname', :type => :define do
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'letting the host be defined by the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :data => 'baz.example.com',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,CNAME,example.com.record')
      .with_content(/^foo\s+IN\s+CNAME\s+baz\.example\.com\.$/)
     }
  end

  context 'assigning a different host than the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :host => 'bar' ,
        :data => 'baz.example.com',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,CNAME,example.com.record')
      .with_content(/^bar\s+IN\s+CNAME\s+baz\.example\.com\.$/)
     }
  end

end

describe 'dns::record::mx', :type => :define do
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'letting the host be defined by the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :data => 'baz.example.com',
        :preference => 10,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,MX,example.com.record')
      .with_content(/^foo\s+IN\s+MX\s+10\s+baz\.example\.com\.$/)
     }
  end

  context 'assigning a different host than the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :host => 'bar' ,
        :data => 'baz.example.com',
        :preference => 10,
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,MX,example.com.record')
      .with_content(/^bar\s+IN\s+MX\s+10\s+baz\.example\.com\.$/)
     }
  end

end


describe 'dns::record::ns', :type => :define do
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'letting the host be defined by the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :data => 'baz.example.com.',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,NS,example.com.record')
      .with_content(/^foo\s+IN\s+NS\s+baz\.example\.com\.$/)
     }
  end

  context 'assigning a different host than the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :host => 'bar' ,
        :data => 'baz.example.com.',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,NS,example.com.record')
      .with_content(/^bar\s+IN\s+NS\s+baz\.example\.com\.$/)
     }
  end

end


describe 'dns::record::ptr', :type => :define do
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'letting the host be defined by the resource name' do
    let :params do {
        :zone => '0.0.127.IN-ADDR.ARPA',
        :title => '1' ,
        :data => 'localhost',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.0.0.127.IN-ADDR.ARPA.1,PTR,0.0.127.IN-ADDR.ARPA.record')
      .with_content(/^1\s+IN\s+PTR\s+localhost\.$/)
     }
  end

  context 'assigning a different host than the resource name' do
    let :params do {
        :zone => '0.0.127.IN-ADDR.ARPA',
        :title => 'foo' ,
        :host => '1' ,
        :data => 'localhost',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.0.0.127.IN-ADDR.ARPA.foo,PTR,0.0.127.IN-ADDR.ARPA.record')
      .with_content(/^1\s+IN\s+PTR\s+localhost\.$/)
     }
  end

end


describe 'dns::record::txt', :type => :define do
  let(:facts) { { :concat_basedir => '/tmp' } }

  context 'letting the host be defined by the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :data => 'baz',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,TXT,example.com.record')
      .with_content(/^foo\s+IN\s+TXT\s+"baz"$/)
     }
  end

  context 'assigning a different host than the resource name' do
    let :params do {
        :zone => 'example.com',
        :title => 'foo' ,
        :host => 'bar' ,
        :data => 'baz.example.com',
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.foo,TXT,example.com.record')
      .with_content(/^bar\s+IN\s+TXT\s+"baz"$/)
     }
  end

end

