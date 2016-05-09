# Class: gitfusion
# ===========================
#
# This module installs and configures Perforce GitFusion
#
# Authors
# -------
#
# Alan Petersen <alanpetersen@mac.com>
#
# Copyright
# ---------
#
# Copyright 2016 Alan Petersen, unless otherwise noted.
#
class gitfusion(
  $p4super,
  $p4super_password,
  $gfp4_password,
  $gf_sys_user      = $gitfusion::params::gf_sys_user,
  $gf_dir           = $gitfusion::params::gf_dir,
  $server           = $gitfusion::params::server,
  $server_id        = $gitfusion::params::server_id,
  $p4port           = $gitfusion::params::p4port,
  $timezone         = $gitfusion::params::timezone,
  $unknownuser      = $gitfusion::params::unknownuser,
  $https            = $gitfusion::params::https,
  $debug            = $gitfusion::params::debug,
) inherits gitfusion::params {

  if ($::hostname == 'localhost') {
    fail('The hostname cannot be \'localhost\'. This causes errors when configuring gitfusion.')
  }

  if !($server in ['local','remote']) {
    fail("${server} is not a valid value for the server parameter. Valid parameters are local or remote")
  }

  if !($unknownuser in ['reject','pusher','unknown']) {
    fail("${unknownuser} is not a valid value for the unknownuser parameter")
  }

  case $::osfamily {
    'redhat': {
      include gitfusion::redhat
    }
    'debian': {
      include gitfusion::debian
    }
    default: {
      fail("Sorry, ${::osfamily} is not currently suppported by the gitfusion module")
    }
  }

  # build the execution command
  $base_cmd = '/opt/perforce/git-fusion/libexec/configure-git-fusion.sh -n'
  $c1 = "--super ${p4super} --superpassword ${p4super_password}"
  $c2 = "--gfp4password ${gfp4_password}"
  $c3 = "--server ${server}"
  $c4 = "--id ${server_id}"
  $c5 = "--p4port ${p4port}"
  $c6 = "--timezone ${timezone}"
  $c7 = "--unknownuser ${unknownuser}"
  if $https {
    $c8 = '--https'
  } else {
    $c8 = ''
  }
  if $debug {
    $c9 = '--debug'
  } else {
    $c9 = ''
  }

  $cmd = "${base_cmd} ${c1} ${c2} ${c3} ${c4} ${c5} ${c6} ${c7} ${c8} ${c9}"

  $config_file = '/opt/perforce/git-fusion/home/perforce-git-fusion/p4gf_environment.cfg'
  exec { 'configure-git-fusion':
    command   => $cmd,
    logoutput => true,
    path      => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    unless    => "grep ^P4PORT ${config_file}",
    require   => Package[$gitfusion::params::pkgname],
  }

}
