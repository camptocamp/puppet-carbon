require 'spec_helper'

describe "carbon::instance" do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      context "Valid configuration" do
        let :pre_condition do
          "
          Exec { path => '/sbin:/bin:/usr/bin:/usr/sbin', }
          class {'::carbon':
            instances => {},
          }
          "
        end

        let (:title) {'a'}

        it {
          is_expected.to compile.with_all_deps
        }

        it {
          is_expected.to contain_ini_setting('cache_a_LINE_RECEIVER_INTERFACE').with({
            :path    => '/etc/carbon/carbon.conf',
            :setting => 'LINE_RECEIVER_INTERFACE',
            :value   => '127.0.0.1',
          })
        }

        it {
          is_expected.to contain_file('/etc/systemd/system/carbon-cache-a.service').
            with_ensure('file')
        }

        it {
          is_expected.to contain_service('carbon-cache-a').
            with_ensure('running')
        }
      end
    end
  end
end
