# frozen_string_literal: true

require 'spec_helper'

describe 'daq::service::rce' do
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
            content: %r{interface=lsst-daq},
          )
        end

        it do
          is_expected.to contain_systemd__unit_file('rce.service').with(
            content: %r{EnvironmentFile=/etc/sysconfig/daq},
          )
        end

        it do
          is_expected.to contain_service('rce')
            .with(
              ensure: 'running',
              enable: true,
            )
            .that_subscribes_to('File[/etc/sysconfig/daq]')
            .that_subscribes_to('Systemd::Unit_file[rce.service]')
        end
      end
    end
  end
end
