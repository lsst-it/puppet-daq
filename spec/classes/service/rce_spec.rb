# frozen_string_literal: true

require 'spec_helper'

describe 'daq::service::rce' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without any parameters' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/sysconfig/daq').with(
            ensure: 'file',
            mode: '0644',
            owner: 'root',
            group: 'root',
            content: %r{interface=lsst-daq}
          )
        end

        it do
          is_expected.to contain_file('/var/lib/vrce').with(
            ensure: 'directory',
            owner: 'root',
            group: 'daq',
            mode: '0775'
          )
        end

        it do
          is_expected.to contain_systemd__unit_file('rce.service').
            with_content(%r{EnvironmentFile=/etc/sysconfig/daq}).
            with_content(%r{ExecStart=/opt/lsst/daq-sdk/current/x86/bin/dsm_startup})
        end

        it do
          is_expected.to contain_service('rce').
            with(
              ensure: 'running',
              enable: true
            ).
            that_subscribes_to('File[/etc/sysconfig/daq]').
            that_subscribes_to('Systemd::Unit_file[rce.service]')
        end
      end
    end
  end
end
