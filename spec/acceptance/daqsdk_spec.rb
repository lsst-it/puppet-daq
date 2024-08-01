# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq::daqsdk class' do
  let(:manifest) do
    <<-PP
    include daq::daqsdk
    PP
  end

  it_behaves_like 'an idempotent resource'

  %w[
    /opt/lsst/daq-sdk
    /opt/lsst/daq-sdk/dl
    /opt/lsst/daq-sdk/R5-V10.3
    /opt/lsst/daq-sdk/R5-V10.3/alinux
    /opt/lsst/daq-sdk/R5-V10.3/examples
    /opt/lsst/daq-sdk/R5-V10.3/include
    /opt/lsst/daq-sdk/R5-V10.3/rtems
    /opt/lsst/daq-sdk/R5-V10.3/x86
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
    it { is_expected.to be_linked_to 'R5-V10.3' }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/opt/lsst/daq-sdk/dl/R5-V10.3.tgz') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
  end

  context '/opt/lsst/daq-sdk/current symlink manually changed' do
    let(:manifest) do
      <<-PP
      include daq::daqsdk
      PP
    end

    before(:context) do
      shell('ln -snf /tmp /opt/lsst/daq-sdk/current')
    end

    after(:context) do
      # cleanup so as not to break other tests
      shell('rm -rf /opt/lsst/daq-sdk/current')
    end

    it_behaves_like 'an idempotent resource'

    describe file('/opt/lsst/daq-sdk/current') do
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to '/tmp' }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end
  end
end
