# == Define: sslh::destination
#
# Configure the destination for a kind of traffic sslh understands
#
# === Parameters
#
# [*type*]
#   The type of traffic to forward. Supported types: ssh, ssl, openvpn, http,
#   xmpp, tinc.
#
# [*address*]
#   The address and port that sslh should forward traffic to.
#
# [*order*]
#   The relative order of this destination, compared to other sslh
#   destinations. Sslh forwards unknown traffic to the first destination, which
#   should normally be configured to be SSH. Defaults to 10 if $type is ssh, or
#   20 otherwise. Must be between 10 and 90.
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
define sslh::destination($type = $title, $address, $order = undef) {
  include sslh

  $supported_types = [ssh, ssl, openvpn, http, xmpp, tinc]
  if !($type in $supported_types) {
    fail("$type is not supported. Valid types are: $supported_types")
  }

  $order_real = $order ? {
    # If unspecified, default SSH to order 10, everything else to order 20
    undef   => $type ? {
      ssh     => 10,
      default => 20,
    },
    default => $order,
  }
  if (!is_numeric($order_real) or $order_real < 10 or $order_real > 90) {
    fail("Invalid order $order_real, must be a number between 10 and 90")
  }

  # Uses: $type, $address
  concat::fragment {"sslh-destination-$type":
    target  => '/etc/default/sslh',
    content => template('sslh/sslh.defaults.destination.erb'),
    order   => $order_real,
  }

}