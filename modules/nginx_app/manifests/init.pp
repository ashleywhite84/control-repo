#
class nginx_app {

  class{'nginx':
      manage_repo    => true,
      package_source => 'nginx-mainline',
  }

  # file { "index.html":
  #   ensure  => file,
  #   content => template("${module_name}/index.html.erb"),
}
