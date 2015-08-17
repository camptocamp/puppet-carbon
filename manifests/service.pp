class carbon::service {
  service{'carbon-cache':
    ensure    => undef,
    enable    => false,
    hasstatus => true,
  }
  service {'carbon-relay':
    ensure   => running,
    provider => 'systemd',
  }
}
