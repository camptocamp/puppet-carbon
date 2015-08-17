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
            :instances   => ['a','b','c'],
            :storage_dir => '/srv/carbon',
          }
        end

        it {
          is_expected.to compile.with_all_deps
        }

        it {
          is_expected.to contain_package('graphite-carbon')
        }

        it {
          is_expected.to contain_package('python-rrdtool')
        }

        it {
          is_expected.to contain_ini_setting('cache_storage_dir')
          .with_path('/etc/carbon/carbon.conf')
          .with_section('cache')
          .with_setting('STORAGE_DIR')
          .with_value('/srv/carbon')
        }

      end
    end
  end
end
