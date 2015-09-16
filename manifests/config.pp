class carbon::config {

  $base_dir = $carbon::config_dir

  $destinations = inline_template('<%=
scope.lookupvar("carbon::instances").keys.sort.map do |instance|
raise(Puppet::ParseError, "#{instance} is not 1, but is #{instance.length}") unless instance.length == 1
"#{scope.lookupvar("carbon::host")}:2#{instance.unpack("c")[0]-87}4:#{instance}"
end.join(", ")
%>')

  ini_setting {
    'cache_storage_dir':
      path    => "${base_dir}/carbon.conf",
      section => 'cache',
      setting => 'STORAGE_DIR',
      value   => $carbon::storage_dir;
    'cache_conf_dir':
      path    => "${base_dir}/carbon.conf",
      section => 'cache',
      setting => 'CONF_DIR',
      value   => $base_dir;
    'cache_local_data_dir':
      path    => "${base_dir}/carbon.conf",
      section => 'cache',
      setting => 'LOCAL_DATA_DIR',
      value   => "${carbon::storage_dir}/whisper";
    'cache_user':
      path    => "${base_dir}/carbon.conf",
      section => 'cache',
      setting => 'USER',
      value   => $carbon::user;
    'cache_whitelists_dor':
      path    => "${base_dir}/carbon.conf",
      section => 'cache',
      setting => 'WHITELISTS_DIR',
      value   => "${carbon::storage_dir}/lists";
    'relay_destination':
      path    => "${base_dir}/carbon.conf",
      section => 'relay',
      setting => 'DESTINATIONS',
      value   => $destinations;
    'relay_receiver_port':
      path    => "${base_dir}/carbon.conf",
      section => 'relay',
      setting => 'LINE_RECEIVER_PORT',
      value   => '2003';
  } ->

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
    group  => $carbon::group,
    mode   => '0755',
    owner  => $carbon::user,
  }

  file {[
    $carbon::storage_dir,
    "${carbon::storage_dir}/whisper",
    "${carbon::storage_dir}/lists",
    "${carbon::storage_dir}/rrd",
  ]:
    ensure  => directory,
    group   => $carbon::group,
    owner   => $carbon::user,
    require => Package['carbon-cache'],
  }

  file { "${base_dir}/storage-schemas.conf":
    ensure  => file,
    content => '# File managed by puppet
[carbon]
pattern = ^carbon\.
retentions = 60:90d

[collectd]
pattern = ^collectd\.
retentions = 10s:1d,30s:7d,1m:21d,15m:5y

[default_metrics]
pattern = .*
retentions = 15s:7d,1m:21d,15m:8w
',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
    require => Package['carbon-cache'],
  }


}
