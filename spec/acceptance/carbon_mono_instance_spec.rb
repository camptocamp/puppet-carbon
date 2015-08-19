require 'spec_helper_acceptance'

describe 'carbon class' do
  context 'carbon mono_instance' do
    it 'is_expected.to idempotently run' do
      pp = <<-EOS
        if $::osfamily == 'RedHat' {
          class { '::epel':
            before => Class['carbon'],
          }
        }
        class { 'carbon': 
          mono_instance => true,
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('carbon-cache') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe port(2003) do
      it { is_expected.to be_listening }
    end
    describe port(2004) do
      it { is_expected.to be_listening }
    end
  end
end
