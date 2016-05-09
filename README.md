# gitfusion

## Overview

Installs and configures Perforce Git Fusion. See the following for more information:

- [GitFusion Administration Guide](https://www.perforce.com/perforce/doc.current/manuals/git-fusion/)

## Usage

**NOTE:** This version of the Git Fusion module installs the Git Fusion binaries, but does not install the helix p4d service. Git Fusion can be configured to point to a local instance or remote instance.

~~~
class { 'gitfusion':
  p4super          => 'p4super',
  p4super_password => 'p@ssw0rd',
  gfp4_password    => 'p@ssw0rd',
}
~~~

## Class Parameters

The following parameters are available in the gitfusion class:

- p4super -- **REQUIRED** -- the existing superuser account that will be used to configure the Git Fusion repo, triggers, etc. in the Perforce Helix instance.
- p4super_password -- **REQUIRED** -- the password for the Perforce superuser account.
- gfp4_password -- **REQUIRED** -- the password to be used for the Git Fusion accounts created in Perforce.
- gf_sys_user --  the system user to run Git Fusion as. If the user does not exist, it will be created. Defaults to "git".
- gf_dir -- the path to the Git Fusion executable files.
- server -- the server type to be used with this Git Fusion instance. This defaults to 'local'. The valid values are:
	- local  = use an existing Perforce service on this machine
	- remote = use an existing Perforce service on another machine
- server_id -- the server id used to identify the Git Fusion server. Defaults to the current hostname.
- p4port -- the P4PORT for the Perforce service. Defaults to '1666'.
- timezone -- the Perforce service's timezone in Olson format.
- unknownuser -- a flag that specifies how to handle the Perforce change owner for git commits authored by non-Perforce users. This defaults to 'reject'
	- reject  = reject push which contains commits authored by non-Perforce users
	- pusher  = accept commits authored by non-Perforce users and set the change owner to the pusher
	- unknown = accept commits authored by non-Perforce users and set the change owner to 'unknown_git'
- https -- a boolean indicating whether or not Git Fusion should support HTTPS protocol using Apache. **NOTE** This module does not install Apache, that would have to be done before this module is configured.
- debug -- a boolean flag which turns on debugging for the Git Fusion installer.

## Hiera Usage Example

You can provide data for your Git Fusion management using Hiera. To do this, simply classify your node

`include gitfusion`

and then in your hiera data provide something like:

~~~
gitfusion::p4super: p4superuser
gitfusion::p4super_password: p4superuserpassword
gitfusion::gfp4_password: git_fusion_user_password
gitfusion::server: local
gitfusion::p4port: 1666
~~~

