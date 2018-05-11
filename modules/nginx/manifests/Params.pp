class nginx::Params (
  )
  {
    include nginx
  Package{'nginx':
  ensure => 'latest',
# source => 'yum',
  }
