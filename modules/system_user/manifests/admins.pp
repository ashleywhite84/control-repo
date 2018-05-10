class system_user::admins {

  Package { 'csh':
    ensure => 'latest',
        }
  group { 'staff':
    ensure => 'present',
        }
  user { 'admin':
    groups  => 'staff',
    shell   => '/bin/csh',
    require => Package['csh'],
  }
}
