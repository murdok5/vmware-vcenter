class vcenter::install {

  $packages_rhel = [ 'zlib-devel', 'libxslt-devel', 'patch', 'gcc']
  $packages_debian = [ 'zlib1g-dev', 'libxslt1-dev', 'build-essential']

  package { $packages_rhel:
    ensure => present,
  }

  package { 'rbvmomi':
    ensure   => present,
    provider => puppetserver_gem,
  }

  package { 'hocon':
    ensure   => present,
    provider => puppetserver_gem,
  }
}
