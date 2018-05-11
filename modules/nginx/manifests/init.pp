#
class nginx {

    include nginx
  Package{'nginx':
  ensure => 'latest',
# source => 'yum',
  }
}
