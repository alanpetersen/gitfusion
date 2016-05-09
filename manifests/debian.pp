#
class gitfusion::debian (
  $pkgname               = $gitfusion::params::pkgname,
  $pubkey_url            = $gitfusion::params::pubkey_url,
  $p4_key_fingerprint    = $gitfusion::params::p4_key_fingerprint,
  $p4_distro_location    = $gitfusion::params::p4_distro_location,
  $p4_distro_release     = $gitfusion::params::p4_distro_release,
) inherits gitfusion::params {

  include apt

  if !defined(Apt::Key['perforce-key']) {
    apt::key { 'perforce-key':
      ensure => present,
      id     => $p4_key_fingerprint,
      source => $pubkey_url,
    }
  }

  if !defined(Apt::Source['perforce-apt-config']) {
    apt::source { 'perforce-apt-config':
      comment  => 'This is the Perforce debian distribution configuration file',
      location => $p4_distro_location,
      release  => $p4_distro_release,
      repos    => 'release',
      require  => Apt::Key['perforce-key'],
      include  => {
        'src' => false,
        'deb' => true,
      },
    }
  }

  if !defined(Package[$pkgname]) {
    package { $pkgname:
      ensure  => installed,
      require => Exec['apt_update'],
    }
  }

}
