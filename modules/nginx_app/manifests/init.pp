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
    ensure                             => 'present',
    auto_start                         => 'true',
    cpu_action                         => 'NoAction',
    cpu_reset_interval                 => '00:05:00',
    cpu_smp_affinitized                => 'false',
    cpu_smp_processor_affinity_mask    => '4294967295',
    cpu_smp_processor_affinity_mask2   => '4294967295',
    disallow_overlapping_rotation      => 'false',
    disallow_rotation_on_config_change => 'false',
    enable32_bit_app_on_win64          => 'false',
    enable_configuration_override      => 'true',
    identity_type                      => 'SpecificUser',
    idle_timeout                       => '00:20:00',
    idle_timeout_action                => 'Terminate',
    load_balancer_capabilities         => 'HttpLevel',
    load_user_profile                  => 'false',
    log_event_on_process_model         => 'IdleTimeout',
    log_event_on_recycle               => 'Time,Memory,PrivateMemory',
    logon_type                         => 'LogonBatch',
    managed_pipeline_mode              => 'Integrated',
    managed_runtime_version            => 'v4.0',
    manual_group_membership            => 'false',
    max_processes                      => '1',
    orphan_worker_process              => 'false',
    pass_anonymous_token               => 'true',
    password                           => $service_account_password,
    ping_interval                      => '00:00:30',
    ping_response_time                 => '00:01:30',
    pinging_enabled                    => 'true',
    queue_length                       => '1000',
    rapid_fail_protection              => 'true',
    rapid_fail_protection_interval     => '00:05:00',
    rapid_fail_protection_max_crashes  => '5',
    set_profile_environment            => 'true',
    shutdown_time_limit                => '00:01:30',
    start_mode                         => 'OnDemand',
    startup_time_limit                 => '00:01:30',
    state                              => 'started',
    user_name                          => $service_account_username,
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
