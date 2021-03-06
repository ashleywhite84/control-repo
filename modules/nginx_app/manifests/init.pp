#
class nginx_app (

String $docroot = "/var/www",
String $portnum = "80",
String $service_account_username         = '',
String $service_account_password         = '',
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
owner   => 'www-data',
group   => 'www-data',
mode    =>  '0755',
source  => "puppet:///modules/${module_name}/index.html",
require => File["${docroot}"],
}
}
else {
include chocolatey

package {'powershell':
provider => 'chocolatey',
notify   => Reboot['Reboot-powershell'],
}

reboot { 'Reboot-powershell':
  apply  => finished,
}
dsc_windowsfeature {'IIS':
  dsc_ensure => 'present',
  dsc_name   => 'Web-Server',
  notify     => Reboot['iisinstall'],
}

dsc_windowsfeature {'IIS-Scripting-Tools':
  dsc_ensure => 'present',
  dsc_name   => 'Web-Scripting-Tools',
}

dsc_windowsfeature {'Web-Mgmt-Console':
  dsc_ensure => 'present',
  dsc_name   => 'Web-Mgmt-Console',
}

reboot { 'iisinstall':
  apply   => finished,
}

# iis_site {'Default Web Site':
# ensure         => 'absent',
# }

iis_application_pool { "DefaultAppPool":
    ensure        => 'present',
  }

iis_site { 'minimal':
  ensure          => 'started',
  physicalpath    => 'c:\\inetpub\\minimal',
  applicationpool => 'DefaultAppPool',
  require         => [File['IIS Minimal Directory'], Dsc_windowsfeature['IIS-Scripting-Tools'], Dsc_windowsfeature['IIS']],
}

file { 'IIS Minimal Directory':
  ensure         => directory,
  path           => 'c:\\inetpub\\miniaml',
}

-> file { "c:\\inetpub\\miniaml\\Web.Config":
ensure  => file,
content => template("${module_name}/Web.Config.erb"),
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
