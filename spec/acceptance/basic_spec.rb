# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq class' do
  let(:pp) do
    <<-PP
    accounts::user { 'dsid': }
    accounts::user { 'rce': }

    include daq
    PP
  end

  it_behaves_like 'an idempotent resource'

  describe file('/etc/lsst') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '755' } # serverspec does not like a leading 0
  end

  describe file('/etc/lsst/daq.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '644' } # serverspec does not like a leading 0
  end

  %w[dsid rce].each do |svc|
    describe service(svc) do
      # does not work on el7
      # it { is_expected.to be_installed }
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
