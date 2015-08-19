class carbon::install {
  package {'carbon-cache':
    ensure => present,
    name   => $carbon::carbon_cache_pkg,
  }

  package {'python-rrd':
    ensure => present,
    name   => $carbon::python_rrdtools_pkg,
  }
}
