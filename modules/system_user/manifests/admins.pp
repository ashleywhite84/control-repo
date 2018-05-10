class system_user::admins {

  group { 'staff':
    ensure => 'present',
        }

if $facts['kernel'] == 'windows' {
  user { 'admin':
  groups  => ['staff','users']
}
} else {
package { 'csh':
  ensure => 'latest'
}
user { 'admin':
  groups  => 'staff',
  shell   => '/bin/csh',
  require => Package['csh'],
    }
}
}
