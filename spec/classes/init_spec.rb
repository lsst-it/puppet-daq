# frozen_string_literal: true

require 'spec_helper'

describe 'daq' do
  on_supported_os.each do |_os, facts|
    let(:facts) do
      facts
    end

    describe 'without any parameters' do
      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_file('/etc/lsst').with(
          ensure: 'directory',
          owner: 'root',
          group: 'root',
        )
      end

      it do
        is_expected.to contain_file('/etc/lsst/daq.conf').with(
          ensure: 'file',
          owner: 'root',
          group: 'root',
          content: %r{interface=lsst-daq},
        )
      end

      %w[rce dsid].each do |svc|
        it do
          is_expected.to contain_systemd__unit_file("#{svc}.service").with(
            content: %r{EnvironmentFile=/etc/lsst/daq.conf},
          ).that_comes_before("Service[#{svc}]")
        end

        it do
          is_expected.to contain_service(svc).with(
            enable: true,
          ).that_subscribes_to('File[/etc/lsst/daq.conf]')
        end
      end
    end
  end
end
