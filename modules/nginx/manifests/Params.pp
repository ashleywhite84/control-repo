class nginx::Params (
  Package{'nginx':
  ensure => 'latest',
  source => 'yum',
  }
)
