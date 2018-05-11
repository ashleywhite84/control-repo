#
class nginx_app (

  )
{
  include chocolatey

  if $facts['kernel'] ~= /[Ll]inux/ {
    package { 'nginx':
     ensure   => latest,
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
