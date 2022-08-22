# frozen_string_literal: true

require 'spec_helper'

describe 'daq' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without any parameters' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/opt/lsst').with(
            ensure: 'directory',
            mode: '0755',
            owner: 'root',
            group: 'root'
          )
        end
      end
    end
  end
end
