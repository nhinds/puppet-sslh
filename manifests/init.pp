# == Class: sslh
#
# Installs and configures sslh on ubuntu systems
#
# === Parameters
#
# [*package_version*]
#   Specify the version of sslh to install. Defaults to 'present'
#
# [*listen_address*]
#   The address and port that sslh should listen on. Defaults to '0.0.0.0:443'
#
# [*ssh_address*]
#   The address and port that sslh should forward SSH connections to.
#
# [*ssl_address*]
#   The address and port that sslh should forward SSL/HTTPS connections to.
#
# [*openvpn_address*]
#   The address and port that sslh should forward OpenVPN connections to.
#
# [*http_address*]
#   The address and port that sslh should forward HTTP connections to.
#
# [*xmpp_address*]
#   The address and port that sslh should forward XMPP connections to.
#
# [*tinc_address*]
#   The address and port that sslh should forward tinc connections to.
#
# === Examples
#
#  class { sslh:
#    ssh_address => 'localhost:22',
#    openvpn_address => 'localhost:1194',
#  }
#
# === Copyright
#
# Copyright 2014 Nicholas Hinds, unless otherwise noted.
#
class sslh(
  $package_version = 'present',
  $listen_address  = '0.0.0.0:443',
  $ssh_address     = undef,
  $ssl_address     = undef,
  $openvpn_address = undef,
  $http_address    = undef,
  $xmpp_address    = undef,
  $tinc_address    = undef,
) {
  package { sslh:
    ensure => $package_version,
  }

  service { sslh:
    ensure  => running,
    enable  => true,
    require => Package[sslh],
  }

  # Uses: $listen_address, $ssh_address, $ssl_address, $openvpn_address,
  # $http_address, $xmpp_address, $tinc_address
  file { '/etc/default/sslh':
    content => template('sslh/sslh.defaults.erb'),
    require => Package[sslh],
    notify  => Service[sslh],
  }
}