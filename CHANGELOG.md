## 2015-12-20 - Release 0.2.0
Big update to support latest Git Fusion

The latest version of Git Fusion no longer supports configuring a
p4d instance -- instead you point the configuration script at an
existing p4d instance (either local or remote) using the server and
p4port options.

This update also addresses some duplicate dependency issues when
used with other modules (e.g. the helix one) by checking to first see
if resources exist before managing them.

## 2015-12-20 - Release 0.1.0
### Summary
This is the initial release. Mostly functional, some documentation still needed.
