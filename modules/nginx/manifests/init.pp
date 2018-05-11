#
class nginx (
  string $path = ''
  )

{

    include nginx
  Package{'nginx':
  ensure => 'latest',
# source => 'yum',
  }
  file { "index.html":
    ensure  => file,
    content => template("${module_name}/index.html.erb"),
}
