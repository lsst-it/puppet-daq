# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq::rptsdk class' do
  let(:pp) do
    <<-PP
    include daq::rptsdk
    PP
  end

  it_behaves_like 'an idempotent resource'

  %w[
    /opt/lsst/rpt-sdk
    /opt/lsst/rpt-sdk/dl
    /opt/lsst/rpt-sdk/V3.5.3
    /opt/lsst/rpt-sdk/V3.5.3/arm-linux-rceCA9
    /opt/lsst/rpt-sdk/V3.5.3/arm-rtems-rceCA9
    /opt/lsst/rpt-sdk/V3.5.3/i86-linux-64
  ].each do |dir|
    describe file(dir) do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '755' } # serverspec does not like a leading 0
    end
  end

  describe file('/opt/lsst/rpt-sdk/current') do
    it { is_expected.to be_symlink }
    it { is_expected.to be_linked_to 'V3.5.3' }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/opt/lsst/rpt-sdk/dl/rce-sdk-V3.5.3.tar.gz') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
  end
end
