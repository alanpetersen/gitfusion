#
class gitfusion::params {

  #these values would need to be updated if Perforce updates the public key
  $p4_key_fingerprint   = 'E58131C0AEA7B082C6DC4C937123CB760FF18869'
  $pubkey_url           = 'https://package.perforce.com/perforce.pubkey'
  $pkgname              = 'helix-git-fusion'
  $perforce_package_url = 'http://package.perforce.com'

  # Git-Fusion installer parameters
  $gf_sys_user      = 'git'
  $server           = 'new'
  $server_id        = $::hostname
  $p4root           = '/opt/perforce/instance'
  $p4port           = 'ssl::1666'
  $timezone         = $::olson_timezone
  $unknownuser      = 'unknown'
  $unicode          = true
  $https            = true

  case $::osfamily {
    'redhat': {
      if !($::operatingsystemmajrelease in ['6','7']) {
        fail('Sorry, only releases 6 and 7 are currently suppported by the gitswarm module')
      }
      $perforce_repo_name = 'perforce'
      $yum_baseurl        = "${perforce_package_url}/yum/rhel/${::operatingsystemmajrelease}/x86_64"
    }
    'debian': {
      if !($::lsbdistcodename in ['precise','trusty']) {
        fail('Sorry, only the precise or trusty distros are currently suppported by the gitswarm module')
      }
      $p4_distro_location = "${perforce_package_url}/apt/ubuntu"
      $p4_distro_release  = $::lsbdistcodename
    }
    default: {
      fail("Sorry, ${::osfamily} is not currently suppported by the gitswarm module")
    }
  }

}
