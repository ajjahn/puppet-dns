require 'spec_helper_acceptance'

describe 'basic dns' do
  context 'default parameters' do
    let(:pp) do
      "
        include dns::server
        dns::server::options{'/etc/bind/named.conf.options': forwarders => ['8.8.8.8', '8.8.4.4'], }
      "
    end

    it 'is_expected.to apply with no errors' do
      apply_manifest(pp, catch_failures: true)
    end
    it 'is_expected.to be idempotent' do
      apply_manifest(pp, catch_changes: true)
    end
  end
end
