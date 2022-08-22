# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq::service::rce class' do
  let(:manifest) do
    <<-PP
    group { 'daq': }
    user { 'rce': gid => 'daq' }

    class { 'daq':
      interface => $facts['networking']['primary'],
    }
    include daq::service::rce
    PP
  end

  it_behaves_like 'an idempotent resource'

  describe file('/etc/sysconfig/daq') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
    its(:content) { is_expected.to match %r{interface=#{fact('networking.primary')}} }
    its(:content) { is_expected.to match %r{backingdir=/var/lib/vrce} }
  end

  describe file('/var/lib/vrce') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'daq' }
    it { is_expected.to be_mode '775' } # serverspec does not like a leading 0
  end

  describe service('rce') do
    # does not work on el7
    # it { is_expected.to be_installed }
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe process('dsm.service') do
    its(:user) { is_expected.to eq 'rce' }
    its(:count) { is_expected.to eq 8 }
  end
end
