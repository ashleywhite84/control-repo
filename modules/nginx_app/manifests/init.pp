#
class nginx_app {

  include chocolatey

  if $facts['kernel'] == 'windows' {
    Package { 'nginx':
    ensure => '1.12.2',
    source => 'chocolatey'
  }
  } else {
  package { 'nginx':
    ensure => '1.12.2',
  }


  # file { "index.html":
  #   ensure  => file,
  #   content => template("${module_name}/index.html.erb"),
}
}
