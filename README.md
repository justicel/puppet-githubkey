# githubkey

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with githubkey](#setup)
    * [What githubkey affects](#what-githubkey-affects)
    * [Beginning with githubkey](#beginning-with-githubkey)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module allows you to input an array of github usernames and import their public key
entries to the local system. This allows you to do fun things like have development systems
which lock down to a specific set of developers without needing to store their public keys locally!

## Module Description

Setup of authorized_keys file based upon an array of github usernames.

## Setup

    puppet module install jlondon/githubkey

### What githubkey affects

* The authorized_keys file for the specified system username will be modified by puppet
* Don't add usernames if you don't EXPLICITLY want them to be able to login to your servers.
  They can and potentially WILL login via ssh if you give them access!

### Beginning with githubkey

* Requires the puppet-stdlib module.

## Usage

Based upon a list of usernames fed to the class we can import SSH public keys from github to a local authorized_keys file:

    class {'githubkey':
      ensure            => present,
      auth_user         => 'root',
      github_auth_user  => 'myuser',
      github_auth_token => '124135213562n246346346',
      usernames         => ['github'],
    }

## Limitations

Should support any standard Puppet compatible OS as it doesn't really do anything
based upon system commands.

## Development

Feel free to add or remove features to this module. If you do something great
please open a pull request so it can be added to the main module!
