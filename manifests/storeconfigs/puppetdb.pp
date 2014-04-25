class puppet::storeconfigs::puppetdb (
  $puppetdb_terminus_package  = $puppet::params::puppetdb_terminus_package,
  $puppetdb_terminus_version  = $puppet::params::puppetdb_terminus_version,
  $dbserver                   = $puppet::params::dbserver,
  $dbport                     = '8081',
  $package_provider           = undef
) {

  include puppet::params

  package { $puppetdb_terminus_package:
    ensure    => $puppetdb_terminus_version,
    provider  => $package_provider
  }

  file { '/etc/puppet/puppetdb.conf':
    ensure  => present,
    content => template('puppet/puppetdb.conf.erb'),
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
  }
}
