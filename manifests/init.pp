class carbon(
  $carbon_cache_pkg    = $carbon::params::carbon_cache_pkg,
  $config_dir          = '/etc/carbon',
  $host                = '127.0.0.1',
  $group               = $carbon::params::group,
  $instances           = {
    'a' => { user => $carbon::params::user, group => $carbon::params::group},
    'b' => { user => $carbon::params::user, group => $carbon::params::group},
    'c' => { user => $carbon::params::user, group => $carbon::params::group}
  },
  $mono_instance       = false,
  $python_rrdtools_pkg = $carbon::params::python_rrdtools_pkg,
  $user                = $carbon::params::user,
  $storage_dir         = '/var/lib/carbon',
) inherits carbon::params {

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
