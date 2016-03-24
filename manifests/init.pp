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
# [*timeout*]
#   Seconds to wait before connecting to --on-timeout address.
#
# [*on_timeout*]
#   Connect to specified address upon timeout.
#
# === Examples
#
#  include sslh
#
#  sslh::destination { ssh:
#    address => 'localhost:22',
#  }
#
#  sslh::destination { openvpn:
#    address => '1.2.3.4:1194',
#  }
#
# === Copyright
#
# Copyright 2014 Nicholas Hinds, unless otherwise noted.
#
class sslh(
  $package_version = 'present',
  $listen_address  = '0.0.0.0:443',
  $timeout         = undef,
  $on_timeout      = undef,
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

  concat { '/etc/default/sslh':
    ensure_newline => false,
    require        => Package[sslh],
    notify         => Service[sslh],
  }

  # Uses: $listen_address
  concat::fragment { 'sslh-header':
    target  => '/etc/default/sslh',
    content => template('sslh/sslh.defaults.header.erb'),
    order   => 01,
  }

  # Uses: none
  concat::fragment { 'sslh-footer':
    target  => '/etc/default/sslh',
    content => template('sslh/sslh.defaults.footer.erb'),
    order   => 99,
  }
}
