require 'spec_helper_acceptance'

describe 'basic dns' do

 context 'default parameters' do
    let(:pp) {"
      include dns::server
    "}
    it 'should apply with no errors' do
      apply_manifest(pp, :catch_failures=>true)
    end
    it 'should be idempotent' do
      apply_manifest(pp, :catch_changes=>true)
    end
  end

end
