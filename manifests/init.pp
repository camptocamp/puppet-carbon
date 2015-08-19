class carbon(
  $carbon_cache_pkg    = $carbon::params::carbon_cache_pkg,
  $config_dir          = '/etc/carbon',
  $host                = '127.0.0.1',
  $group               = '_graphite',
  $instances           = {'a'=>{}, 'b'=>{}, 'c'=>{}},
  $mono_instance       = false,
  $python_rrdtools_pkg = $carbon::params::python_rrdtools_pkg,
  $user                = '_graphite',
  $storage_dir         = '/var/lib/carbon',
) inherits carbon::params {

  validate_string($user)
  validate_string($group)
  validate_hash($instances)
  validate_bool($mono_instance)
  validate_absolute_path($storage_dir)

  if $::osfamily == 'RedHat' and $carbon_cache_pkg == undef {
    fail "Please provide a value for 'carbon_cache_pkg' on $::osfamily"
  }
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
