class vcenter::install {

  $packages_rhel = [ 'zlib-devel', 'libxslt-devel', 'patch', 'gcc']
  $packages_debian = [ 'zlib1g-dev', 'libxslt1-dev', 'build-essential']

  package { $packages_rhel:
    ensure => present,
  }

  package { 'nokogiri':
    ensure   => '1.7.2',
    provider => puppet_gem,
  }

  package { 'rbvmomi':
    ensure   => '1.11.2',
    provider => puppet_gem,
  }

  package { 'hocon':
    ensure   => present,
    provider => puppet_gem,
  }
}
