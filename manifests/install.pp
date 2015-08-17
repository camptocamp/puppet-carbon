class carbon::install {
  package { ['graphite-carbon', 'python-rrdtool']:
    ensure => present,
  }
}
