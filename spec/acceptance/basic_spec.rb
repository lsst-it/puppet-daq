# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daq class' do
  let(:pp) do
    <<-PP
    include daq
    PP
  end

  it_behaves_like 'an idempotent resource'

  describe file('/opt/lsst') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
    it { is_expected.to be_mode '755' } # serverspec does not like a leading 0
  end
end
