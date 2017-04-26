# == Class: sslh::import_destinations
#
# Imports sslh::destination resources that have been exported from other nodes
#
# === Examples
#
#  @@sslh::destination { ssh:
#    address => "${::ipaddress}:22",
#  }
#
#  include sslh::import_destinations
#
# === Copyright
#
# Copyright 2014 Nicholas Hinds, unless otherwise noted.
#
class sslh::import_destinations {
  Sslh::Destination <<| |>>
}
