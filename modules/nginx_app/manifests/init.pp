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
  file { '/etc/nginx/sites-available/default':
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => template("${module_name}/default.erb"),
  require => Service['nginx'],
}
service { 'nginx':
  ensure  => 'running',
  require => Package['nginx'],
}
file { $docroot:
owner   => 'www-data',
group   => 'www-data',
mode    => '0755',
recurse => true,
require => Package['nginx'],

}
file { "$docroot/index.html":
owner   => 'www-date',
group   => 'www-data',
mode    =>  '0755',
source  => "puppet:///modules/${module_name}/index.html",
require => File["${docroot}"],
}
}
else {
include chocolatey

package {'nginx':
provider => 'chocolatey',
}
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
