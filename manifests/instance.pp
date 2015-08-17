define carbon::instance(
  $ensure                       = present,
  $cache_query_interface        = '127.0.0.1',
  $line_receiver_interface      = '127.0.0.1',
  $group                        = '_graphite',
  $local_data_dir               = '/var/lib/carbon/whisper',
  $log_cache_hits               = 'false',
  $log_updates                  = 'false',
  $max_cache_size               = 'inf',
  $max_creates_per_minute       = 50,
  $max_updates_per_second       = 1000,
  $pickle_receiver_interface    = '127.0.0.1',
  $storage_dir                  = '/var/lib/carbon',
  $user                         = '_graphite',
  $whitelists_dir               = '/var/lib/carbon/lists'
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

  Ini_setting {
    ensure  => $ensure,
    path    => "${carbon::config_dir}/carbon.conf",
    section => "cache:${name}",
  }
  $port = inline_template('<%= @name.ord-87 %>')
  ini_setting {
    "cache_${name}_LINE_RECEIVER_INTERFACE":
      setting => 'LINE_RECEIVER_INTERFACE',
      value   => $line_receiver_interface;
    "cache_${name}_PICKLE_RECEIVER_INTERFACE":
      setting => 'PICKLE_RECEIVER_INTERFACE',
      value   => $pickle_receiver_interface;
    "cache_${name}_CACHE_QUERY_INTERFACE":
      setting => 'CACHE_QUERY_INTERFACE',
      value   => $cache_query_interface;
    "cache_${name}_LINE_RECEIVER_PORT":
      setting => 'PICKLE_RECEIVER_PORT',
      value   => "2${port}3";
    "cache_${name}_PICKLE_RECEIVER_PORT":
      setting => 'PICKLE_RECEIVER_PORT',
      value   => "2${port}4";
    "cache_${name}_CACHE_QUERY_PORT":
      setting => 'CACHE_QUERY_PORT',
      value   => "7${port}2";
    "cache_${name}_USER":
      setting => 'USER',
      value   => $user;
    "cache_${name}_STORAGE_DIR":
      setting => 'STORAGE_DIR',
      value   => $storage_dir;
    "cache_${name}_LOCAL_DATA_DIR":
      setting => 'LOCAL_DATA_DIR',
      value   => $local_data_dir;
    "cache_${name}_WHITELISTS_DIR":
      setting => 'WHITELISTS_DIR',
      value   => $whitelists_dir;
    "cache_${name}_LOG_UPDATES":
      setting => 'LOG_UPDATES',
      value   => $log_updates;
    "cache_${name}_LOG_CACHE_HITS":
      setting => 'LOG_CACHE_HITS',
      value   => $log_cache_hits;
    "cache_${name}_MAX_CACHE_SIZE":
      setting => 'MAX_CACHE_SIZE',
      value   => $max_cache_size;
    "cache_${name}_MAX_UPDATES_PER_SECOND":
      setting => 'MAX_UPDATES_PER_SECOND',
      value   => $max_updates_per_second;
    "cache_${name}_MAX_CREATES_PER_MINUTE":
      setting => 'MAX_CREATES_PER_MINUTE',
      value   => $max_creates_per_minute;
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
