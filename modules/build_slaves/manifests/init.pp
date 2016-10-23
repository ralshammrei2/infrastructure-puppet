#/etc/puppet/modules/build_slaves/manifests/init.pp

class build_slaves (
  $distro_packages  = [],
  ) {

  class { "build_slaves::install::${::asfosname}::${::asfosrelease}":
  }

  exec { 'Add nodesource-6 sources':
    command => 'if [ ! -f /etc/apt/sources.list.d/nodesource.list ] ; then curl https://deb.nodesource.com/setup_6.x ; fi | bash -',
    creates => '/etc/apt/sources.list.d/nodesource.list',
    path    => ['/usr/bin', '/bin', '/usr/sbin']
  }

  package {
    $distro_packages:
      ensure => installed,
  }

  python::pip { 'Flask' :
    pkgname       => 'Flask';
  }

## temporary block -- cml -- remove old .save and duplicate declares ##

  exec { 'delete extra sources.list.d files':
    command => "/bin/rm -f /etc/apt/sources.list.d/*.save",
  } -> 
  exec { 'delete dupe sources.list.d files':
    command => "/bin/rm -f /etc/apt/sources.list.d/packages_apache_org_asf_internal.list /etc/apt/sources.list.d/get_docker_io_ubuntu.list",
  }

## end temporary block

}
