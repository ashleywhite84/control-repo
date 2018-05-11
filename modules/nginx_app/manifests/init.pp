#
class nginx_app {

  class{'nginx':}

  # file { "index.html":
  #   ensure  => file,
  #   content => template("${module_name}/index.html.erb"),
}
