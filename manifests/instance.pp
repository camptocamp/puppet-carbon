define carbon::instance(
  $ensure = present,
  $group  = '_graphite',
  $user   = '_graphite',
) {

  contain ::systemd

  $f_ensure = $ensure? {
    'present' => 'file',
    default   => $ensure,
  }

  $s_ensure = $ensure? {
    'present' => 'running',
    default   => 'stopped',
  }

  concat::fragment {"carbon instance ${name}":
    ensure  => $ensure,
    content => template('carbon/instance.erb'),
    target  => '/etc/carbon/carbon.conf',
  }->
  file {"/etc/systemd/system/carbon-cache-${name}.service":
    ensure  => $f_ensure,
    content => template('carbon/carbon-systemd.erb'),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    notify  => Exec['systemctl-daemon-reload'],
  }
  service {"carbon-cache-${name}":
    ensure     => $s_ensure,
    hasstatus  => true,
    hasrestart => false,
    provider   => 'systemd',
    require    => Exec['systemctl-daemon-reload'],
  }
}
