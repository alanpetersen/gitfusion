# Class: gitfusion
# ===========================
#
# This module installs and configures Perforce GitFusion
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2015 Alan Petersen, unless otherwise noted.
#
class gitfusion(
  $p4super,
  $p4super_password,
  $gfp4_password,
  $gf_sys_user      = $gitfusion::params::gf_sys_user,
  $server           = $gitfusion::params::server,
  $server_id        = $gitfusion::params::server_id,
  $p4root           = $gitfusion::params::p4root,
  $p4port           = $gitfusion::params::p4port,
  $timezone         = $gitfusion::params::timezone,
  $unknownuser      = $gitfusion::params::unknownuser,
  $unicode          = $gitfusion::params::unicode,
  $https            = $gitfusion::params::https,
) inherits gitfusion::params {

  if !($server in ['new','local','remote']) {
    fail("${server} is not a valid value for the server parameter")
  }

  if ($server == 'new' and $p4root == undef) {
    fail('p4root must be defined when a new server is being defined')
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

  if $server == 'new' {
    $c5 = "--p4root ${p4root}"
  } else {
    $c5 = ''
  }

  $c6 = "--p4port ${p4port}"
  $c7 = "--timezone ${timezone}"

  $c8 = "--unknownuser ${unknownuser}"

  if $unicode {
    $c9 = '--unicode'
  } else {
    $c9 = ''
  }

  if $https {
    $c10 = '--https'
  } else {
    $c10 = ''
  }

  $cmd = "${base_cmd} ${c1} ${c2} ${c3} ${c4} ${c5} ${c6} ${c7} ${c8} ${c9} ${c10}"

  $config_file = '/opt/perforce/git-fusion/home/perforce-git-fusion/p4gf_environment.cfg'
  exec { 'configure-git-fusion':
    command   => $cmd,
    logoutput => true,
    path      => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    unless    => "grep ^P4PORT ${config_file}",
    require   => Package[$gitfusion::params::pkgname],
  }

}
