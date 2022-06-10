# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq::daqsdk class' do
  let(:pp) do
    <<-PP
    include daq::daqsdk
    PP
  end

  it_behaves_like 'an idempotent resource'

  %w[
    /opt/lsst/daq-sdk
    /opt/lsst/daq-sdk/dl
    /opt/lsst/daq-sdk/R5-V3.2
    /opt/lsst/daq-sdk/R5-V3.2/alinux
    /opt/lsst/daq-sdk/R5-V3.2/examples
    /opt/lsst/daq-sdk/R5-V3.2/include
    /opt/lsst/daq-sdk/R5-V3.2/rtems
    /opt/lsst/daq-sdk/R5-V3.2/x86
  ].each do |dir|
    describe file(dir) do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode '755' } # serverspec does not like a leading 0
    end
  end

  describe file('/opt/lsst/daq-sdk/current') do
    it { is_expected.to be_symlink }
    it { is_expected.to be_linked_to 'R5-V3.2' }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/opt/lsst/daq-sdk/dl/R5-V3.2.tgz') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
  end
end
