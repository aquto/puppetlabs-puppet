# Class: puppet::storedconfiguration
#
# This class installs and configures Puppet's stored configuration capability
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppet::storeconfigs (
  $dbadapter        = $puppet::params::storeconfigs_dbadapter,
  $dbuser           = $puppet::params::storeconfigs_dbuser,
  $dbpassword       = $puppet::params::storeconfigs_dbpassword,
  $dbserver         = $puppet::params::storeconfigs_dbserver,
  $dbsocket         = $puppet::params::storeconfigs_dbsocket,
  $dbport           = undef,
  $package_provider = undef
) {

  package { $puppet::params::activerecord_package:
    ensure    => latest,
    provider  => $package_provider,
  }

  case $dbadapter {
    'sqlite3': {
      include puppet::storeconfigs::sqlite
    }
    'mysql': {
      class {
        "puppet::storeconfigs::mysql":
          dbuser     => $dbuser,
          dbpassword => $dbpassword,
      }
    }
    'puppetdb': {
      class { 'puppet::storeconfigs::puppetdb':
        dbserver          => $dbserver,
        dbport            => $dbport,
        package_provider  => $package_provider,
      }
    }
    default: { err("target dbadapter $dbadapter not implemented") }
  }

  concat::fragment { 'puppet.conf-master-storeconfig':
    order   => '06',
    target  => "/etc/puppet/puppet.conf",
    content => template("puppet/puppet.conf-master-storeconfigs.erb");
  }

}

