#
class gitfusion::redhat(
  $pkgname            = $gitfusion::params::pkgname,
  $pubkey_url         = $gitfusion::params::pubkey_url,
  $yum_baseurl        = $gitfusion::params::yum_baseurl,
  $perforce_repo_name = $gitfusion::params::perforce_repo_name,
) inherits gitfusion::params {

  if !defined(Yumrepo[$perforce_repo_name]) {
    yumrepo { $perforce_repo_name:
      baseurl  => $yum_baseurl,
      descr    => 'Perforce Repo',
      enabled  => '1',
      gpgcheck => '1',
      gpgkey   => $pubkey_url,
    }
  }

  if !defined(Package[$pkgname]) {
    package { $pkgname:
      ensure  => installed,
      require => Yumrepo[$perforce_repo_name],
    }
  }
}
