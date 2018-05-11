#
class nginx_app {

  include chocolatey

  if $facts['kernel'] == 'windows' {
    package { 'nginx':
    ensure   => '1.12.2',
    provider => 'chocolatey',
  }
  } else {
  package { 'nginx':
    ensure => 'latest',
  }


  # file { "index.html":
  #   ensure  => file,
  #   content => template("${module_name}/index.html.erb"),
}
}
