# frozen_string_literal: true

require 'spec_helper'

describe 'daq::rptsdk' do
  on_supported_os.each do |_os, facts|
    let(:facts) do
      facts
    end

    describe 'without any parameters' do
      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_file('/opt/lsst/rpt-sdk').with(
          ensure: 'directory',
          mode: '0755',
          owner: 'root',
          group: 'root',
        )
      end

      it do
        is_expected.to contain_file('/opt/lsst/rpt-sdk/dl').with(
          ensure: 'directory',
          mode: '0755',
          owner: 'root',
          group: 'root',
        )
      end

      it do
        is_expected.to contain_archive('/opt/lsst/rpt-sdk/dl/rce-sdk-V3.5.3.tar.gz').with(
          source: 'https://repo-nexus.lsst.org/nexus/repository/daq/rpt-sdk/rce-sdk-V3.5.3.tar.gz',
        )
      end

      it do
        is_expected.to contain_file('/opt/lsst/rpt-sdk/dl/rce-sdk-V3.5.3.tar.gz').with(
          ensure: 'file',
          mode: '0644',
          owner: 'root',
          group: 'root',
        )
      end

      it do
        is_expected.to contain_file('/opt/lsst/rpt-sdk/V3.5.3').with(
          owner: 'root',
          group: 'root',
          recurse: true,
        )
      end

      it do
        is_expected.to contain_file('/opt/lsst/rpt-sdk/current').with(
          ensure: 'link',
          owner: 'root',
          group: 'root',
          target: 'V3.5.3',
        )
      end
    end
  end
end
