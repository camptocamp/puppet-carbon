class carbon(
  $config_dir    = '/etc/carbon',
  $host          = '127.0.0.1',
  $group         = '_graphite',
  $instances     = {'a'=>{}, 'b'=>{}, 'c'=>{}},
  $mono_instance = false,
  $user          = '_graphite',
  $storage_dir   = '/var/lib/carbon',
){

  validate_string($user)
  validate_string($group)
  validate_hash($instances)
  validate_bool($mono_instance)
  validate_absolute_path($storage_dir)

  include ::systemd

  anchor {'carbon::begin': } ->
  class {'::carbon::install': }->
  class {'::carbon::config': } ~>
  class {'::carbon::service': } ->
  anchor {'carbon::end':}

  if !$mono_instance {
    create_resources('carbon::instance', $instances)
  }

}
