require 'spec_helper_acceptance'

describe 'carbon' do
  context 'with defaults' do
    it 'is_expected.to idempotently run' do
      pp = <<-EOS
        class { 'carbon': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('carbon-relay') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe port(2003) do
      it { is_expected.not_to be_listening }
    end
    describe port(2004) do
      it { is_expected.not_to be_listening }
    end

    describe port(2103) do
      it { is_expected.to be_listening }
    end
    describe port(2104) do
      it { is_expected.to be_listening }
    end
    describe port(7102) do
      it { is_expected.to be_listening }
    end

    describe port(2113) do
      it { is_expected.to be_listening }
    end
    describe port(2114) do
      it { is_expected.to be_listening }
    end
    describe port(7112) do
      it { is_expected.to be_listening }
    end

    describe port(2123) do
      it { is_expected.to be_listening }
    end
    describe port(2124) do
      it { is_expected.to be_listening }
    end
    describe port(7122) do
      it { is_expected.to be_listening }
    end
  end

  context 'remove an instance' do
    it 'is_expected.to idempotently run' do
      pp = <<-EOS
        class { 'carbon':
          instances => {
            a => {},
            b => {},
            c => {
              ensure => absent,
            }
          },
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    describe port(2123) do
      it { is_expected.not_to be_listening }
    end
    describe port(2124) do
      it { is_expected.not_to be_listening }
    end
    describe port(7122) do
      it { is_expected.not_to be_listening }
    end
  end
end
