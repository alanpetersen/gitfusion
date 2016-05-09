require 'spec_helper_acceptance'

describe 'gitfusion class' do
  context 'with required parameters only' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
$p4port = '1666'
$superuser = 'p4super'
$superpass = 'p@ssw0rd'

class { 'helix::server': }

helix::server_instance { 'server1':
  p4port  => $p4port,
  require => Class['helix::server'],
  notify  => Exec['configure_protections'],
}

exec { 'configure_protections':
  command     => "p4 -p ${p4port} -u ${superuser} protect -o | p4 -p ${p4port} -u ${superuser} protect -i",
  path        => '/usr/bin:/usr/sbin',
  refreshonly => true,
  notify      => Exec['update_super_pass'],
}
exec { 'update_super_pass':
  command     => "p4 -p ${p4port} -u ${superuser} passwd -P ${superpass} ${superuser}",
  path        => '/usr/bin:/usr/sbin',
  refreshonly => true,
}

class { 'gitfusion':
  server           => 'local',
  p4port           => $p4port,
  p4super          => $superuser,
  p4super_password => $superpass,
  gfp4_password    => $superpass,
  require          => Helix::Server_instance['server1'],
}
EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

  end
end
