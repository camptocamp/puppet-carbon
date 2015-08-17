class carbon(
  $config_dir  = '/etc/carbon',
  $host        = '127.0.0.1',
  $group       = '_graphite',
  $instances   = range('a','h'),
  $user        = '_graphite',
  $storage_dir = '/var/lib/carbon',
){

  validate_string($user)
  validate_string($group)
  validate_array($instances)
  validate_absolute_path($storage_dir)

  contain ::systemd

  class {'::carbon::install': }->
  class {'::carbon::config': }->
  class {'::carbon::service': }

}
