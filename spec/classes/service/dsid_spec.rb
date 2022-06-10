# frozen_string_literal: true

require 'spec_helper'

describe 'daq::service::dsid' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'without any parameters' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/sysconfig/daq').with(
            ensure: 'file',
            mode: '0644',
            owner: 'root',
            group: 'root',
            content: %r{release=/opt/lsst/daq-sdk/current},
          )
        end

        it do
          is_expected.to contain_systemd__unit_file('dsid.service').with(
            content: %r{EnvironmentFile=/etc/sysconfig/daq},
          )
        end

        it do
          is_expected.to contain_service('dsid')
            .with(
              ensure: 'running',
              enable: true,
            )
            .that_subscribes_to('File[/etc/sysconfig/daq]')
            .that_subscribes_to('Systemd::Unit_file[dsid.service]')
        end
      end
    end
  end
end
