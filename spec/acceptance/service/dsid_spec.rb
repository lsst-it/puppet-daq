# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq::service::dsid class' do
  let(:pp) do
    <<-PP
    group { 'daq': }
    user { 'dsid': gid => 'daq' }

    include daq::service::dsid
    PP
  end

  it_behaves_like 'an idempotent resource'

  describe file('/etc/sysconfig/daq') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
    its(:content) { is_expected.to match %r{interface=lsst-daq} }
  end

  describe service('dsid') do
    # does not work on el7
    # it { is_expected.to be_installed }
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
