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

  if fact('os.release.major') == '8'
    describe file('/usr/lib64/libreadline.so.6') do
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to 'libreadline.so.7.0' }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
    end
  end
end
