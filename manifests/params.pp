class carbon::params {
  case $::osfamily {
    'Debian': {
      $carbon_cache_pkg = 'graphite-carbon'
      $python_rrdtools_pkg = 'python-rrdtool'
      $carbon_relay = 'carbon-relay'
      $user = '_graphite'
      $group = '_graphite'
    }
    'RedHat': {
      $carbon_cache_pkg = 'python-carbon'
      $python_rrdtools_pkg = 'rrdtool-python'
      $carbon_relay = 'carbon-relay'
      $user = 'carbon'
      $group = 'carbon'
    }
    default: {
      fail "Operating System family ${::osfamily} not supported"
    }
  }
}
