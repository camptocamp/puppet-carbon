require 'beaker-rspec'

install_puppet_agent_on(hosts, {})

hosts.each do |host|
  if fact('osfamily') == 'RedHat'
    install_package host, 'epel-release'
  end
end

RSpec.configure do |c|
  # Project root
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = File.basename(module_root).split('-').last

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => module_root, :module_name => module_name)

    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','camptocamp-systemd'), { :acceptable_exit_codes => [0,1] }
    end
  end
end

