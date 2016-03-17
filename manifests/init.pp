# == Resource: githubkey
#
# This module allows you to input an array of usernames from github and 
# import them to a local system users authorized keys file
#
# == Parameters
#
# [*ensure*]
#   Ensure can be present or absent which will either add or remove the user keys from the system
#
# [*github_auth_user*]
#   A username for a token/username combo to access github API
#
# [*github_auth_token*]
#   Token for github API access
#
# [*auth_user*]
#   Define the username to store the ssh authorized key file entries to
#
# [*usernames*]
#   An array of usernames to query github api for public keys
#
# === Examples
#
#  githubkey { 'root':
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
# Copyright 2016 Justice London
#
define githubkey (
  $ensure            = present,
  $auth_user         = $name,
  $github_auth_user  = '',
  $github_auth_token = '',
  $usernames,
) {

  # Type validations for variables.
  validate_array($usernames)
  validate_string($github_auth_user)
  validate_string($github_auth_token)
  validate_string($auth_user)

  $ssh_keys = gitssh_import($name, $github_auth_user, $github_auth_token, $usernames)
  $defaults = {
    ensure => $ensure,
    user   => $auth_user,
  }

  #Run through the ssh users returned from gitssh_import() and create them.
  create_resources(ssh_authorized_key, $ssh_keys, $defaults)

}
