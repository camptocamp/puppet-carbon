# Carbon-cache/relay for Puppet

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/carbon.svg)](https://forge.puppetlabs.com/camptocamp/carbon)
[![Build Status](https://travis-ci.org/camptocamp/puppet-carbon.png?branch=master)](https://travis-ci.org/camptocamp/puppet-carbon)

**Manages carbon-cache and carbon-relay with systemd*


## Classes

* carbon

### carbon

Only this class must be used

#### Usage
```Puppet
class {'::carbon':
  carbon_host  => '127.0.0.1',
  carbon_group => '_graphite',
  carbon_user  => '_graphite',
  instrances   => {
    'a': {
      ensure => present,
      cache_query_interface => '127.0.0.2',
      log_cache_hits => 'True',
    },
    'b': {
      ensure => present,
      cache_query_interface => '127.0.0.1',
      log_cache_hits => 'True',
    },
    'c': {
      ensure => absent,
    },
    ...
  },
  storage_dir  => '/srv/carbon',
}
```

It allows to create a multi-instance carbon-cache, launching as many carbon-cache processes as you'd need.
Please take note the instance name must be "one letter". Hence, maximum seems to be 26.

## Definitions

* carbon::instance

## carbon::instance

This definition should NOT be used directly, please use ```carbon``` class instead!

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/camptocamp/puppet-carbon/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](https://github.com/camptocamp/puppet-carbon/issues) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](http://docs.puppetlabs.com/guides/style_guide.html).

## License

Copyright (c) 2013 <mailto:puppet@camptocamp.com> All rights reserved.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

