# == Class: githubkey
#
# This module allows you to input an array of usernames from github and 
# import them to a local system users authorized keys file
#
# == Parameters
#
# [*ensure*]
#   Ensure can be present or absent which will either add or remove the user keys from the system
#
# [*auth_user*]
#   Define the username to store the ssh authorized key file entries to
#
# [*usernames*]
#   An array of usernames to query github api for public keys
#
# === Examples
#
#  class { 'githubkey':
#    ensure    => present,
#    auth_user => 'root',
#    usernames => ['github'],
#  }
#
# === Authors
#
# Justice London <justice.london@gmail.com>
#
# === Copyright
#
# Copyright 2014 Justice London
#
class githubkey (
  $ensure    = present,
  $auth_user = 'root',
  $usernames,
) {

  $ssh_keys = gitssh_import($usernames)
  $defaults = {
    ensure => $ensure,
    user   => $auth_user,
  }

  #Run through the ssh users returned from gitssh_import() and create them.
  create_resources(ssh_authorized_key, $ssh_keys, $defaults)

}
