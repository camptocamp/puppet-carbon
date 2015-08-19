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
            :host        => '127.0.0.1',
            :group       => '_graphite',
            :user        => '_graphite',
            :instances   => {
              'a' => {},
              'b' => {},
              'c' => {},
            },
            :storage_dir => '/srv/carbon',
          }
        end

        it {
          is_expected.to compile.with_all_deps
        }

        it {
          is_expected.to contain_class('carbon::install')
        }
        case facts[:osfamily]
        when 'Debian'
          it {
            is_expected.to contain_package('carbon-cache').with({
              :name => 'graphite-carbon'
            })
          }
          it {
            is_expected.to contain_package('python-rrd').with({
              :name => 'python-rrdtool'
            })
          }
        when 'RedHat'
          it {
            is_expected.to contain_package('carbon-cache').with({
              :name => 'python-carbon'
            })
          }
          it {
            is_expected.to contain_package('python-rrd').with({
              :name => 'rrdtool-python'
            })
          }
        end

        it {
          is_expected.to contain_ini_setting('cache_storage_dir').with({
            :path    => '/etc/carbon/carbon.conf',
            :section => 'cache',
            :setting => 'STORAGE_DIR',
            :value   => '/srv/carbon',
          })
        }

      end
    end
  end
end
