class system_user::admins {

  Package { 'csh':
    ensure => 'latest',
        }
  group { 'staff':
    ensure => 'present',
        }
  user { 'admin':
    group   => 'staff',
    shell   => '/bin/csh',
    require => Package['csh'],
  }
}
