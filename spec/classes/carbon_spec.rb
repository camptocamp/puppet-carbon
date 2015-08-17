require 'spec_helper'

describe "carbon" do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      context "Valid configuration" do
        let :params do
          {
            :carbon_host  => '127.0.0.1',
            :carbon_group => '_graphite',
            :carbon_user  => '_graphite',
            :instances    => ['a','b','c'],
            :storage_dir  => '/srv/carbon',
          }
        end

        it {
          is_expected.to compile.with_all_deps
        }

        it {
          is_expected.to contain_concat('/etc/carbon/carbon.conf')
        }
        it {
          is_expected.to contain_concat__fragment('globals')
          .with_target('/etc/carbon/carbon.conf')
          .with_content(/DESTINATIONS = 127.0.0.1:2104:a, 127.0.0.1:2114:b, 127.0.0.1:2124:c/)
        }
        it {
          is_expected.to contain_file('/etc/carbon/relay-rules.conf')
          .with_content(/destinations = 127.0.0.1:2104:a, 127.0.0.1:2114:b, 127.0.0.1:2124:c/)
        }
        it {
          is_expected.to contain_carbon__instance('a')
        }
        it {
          is_expected.to contain_carbon__instance('b')
        }
        it {
          is_expected.to contain_carbon__instance('c')
        }
      end
    end
  end
end
