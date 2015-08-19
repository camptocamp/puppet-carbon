class carbon::service {
  if $carbon::mono_instance {
    service{'carbon-cache':
      ensure    => running,
      enable    => true,
      hasstatus => true,
    }
  } else {
    service{'carbon-cache':
      ensure    => stopped,
      enable    => false,
      hasstatus => true,
    }
  }
  service {'carbon-relay':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
  }
}
