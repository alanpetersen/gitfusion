require 'spec_helper_acceptance'

describe 'gitfusion class' do
  context 'with required parameters only' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'gitfusion':
        p4super          => 'p4super',
        p4super_password => 'p@ssw0rd',
        gfp4_password    => 'p@ssw0rd',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

  end
end
