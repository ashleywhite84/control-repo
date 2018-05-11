#
class nginx_app (

String $docroot = "/var/www",
String $portnum = "80",
  )
{
  #include chocolatey

if $facts['kernel'] =~ /[Ll]inux/ {
  package { 'nginx':
ensure    => latest,
}
  file {"/etc/nginx/sites-available/default":
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => template("${module_name}//default.erb"),
  require => Package['nginx'],
}
service { 'nginx':
  ensure  => 'running',
  require => Package['nginx'],
  notify  => Service['nginx'],
}
}
else {

}
}
#   }
#   else {
#   package { 'nginx':
#     ensure   => latest,
#     provider => 'chocolatey',
#   }
#
#
#   # file { "index.html":
#   #   ensure  => file,
#   #   content => template("${module_name}/index.html.erb"),
# }
# }
