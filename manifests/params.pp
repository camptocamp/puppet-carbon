class carbon::params {
  case $::osfamily {
    'Debian': {
      $carbon_cache_pkg = 'graphite-carbon'
      $python_rrdtools_pkg = 'python-rrdtool'
    }
    'RedHat': {
      $carbon_cache_pkg = 'python-carbon'
      $python_rrdtools_pkg = 'rrdtool-python'
    }
    default: {
      fail "Operating System family ${::osfamily} not supported"
    }
  }
}
