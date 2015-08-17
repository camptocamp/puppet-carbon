class carbon(
  $carbon_host  = '127.0.0.1',
  $carbon_group = '_graphite',
  $carbon_user  = '_graphite',
  $instances    = range('a','h'),
  $storage_dir  = '/var/lib/carbon',
){

  validate_string($carbon_user)
  validate_string($carbon_group)
  validate_array($instances)
  validate_absolute_path($storage_dir)

  contain ::systemd

  $base_dir = '/etc/carbon'

  package { ['graphite-carbon', 'python-rrdtool']:
    ensure => present,
  }->
  concat {"${base_dir}/carbon.conf":
    group => 'root',
    mode  => '0644',
    owner => 'root',
  }

  concat::fragment {'globals':
    content => template('carbon/globals.conf.erb'),
    order   => '1',
    target  => "${base_dir}/carbon.conf",
  }->
  service{'carbon-cache':
    ensure    => undef,
    enable    => false,
    hasstatus => true,
  }->
  file {"${base_dir}/storage-aggregation.conf":
    ensure  => file,
    content => '# Emtpy, avoid a warning in logs',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }->
  file {"${base_dir}/relay-rules.conf":
    ensure  => file,
    content => template('carbon/relays-rules.conf.erb'),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }->
  file {'/etc/systemd/system/carbon-relay.service':
    ensure  => file,
    content => template('carbon/relay.service.erb'),
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    notify  => Exec['systemctl-daemon-reload'],
  }->
  file {'/var/run/carbon':
    ensure => directory,
    group  => $carbon_group,
    mode   => '755',
    owner  => $carbon_user,
  }->
  service {'carbon-relay':
    ensure   => running,
    provider => 'systemd',
  }->
  ::carbon::instance{$instances: }

  file {[
    "${storage_dir}",
    "${storage_dir}/whisper",
    "${storage_dir}/lists",
    "${storage_dir}/rrd"
  ]:
    ensure  => directory,
    group   => $carbon_group,
    owner   => $carbon_user,
    require => Package['graphite-carbon'],
  }

  file { "${base_dir}/storage-schemas.conf":
    ensure  => file,
    content => '# File managed by puppet
[carbon]
pattern = ^carbon\.
retentions = 60:90d

[default_metrics]
pattern = .*
retentions = 15s:7d,1m:21d,15m:8w
',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    require => Package['graphite-carbon'],
  }
}
