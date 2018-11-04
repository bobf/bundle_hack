# frozen_string_literal: true

RSpec.describe BundleHack::Gem do
  let(:version) { '1.0.0' }

  subject(:gem) do
    described_class.new(
      name: 'dummy_gem',
      version: version,
      path: '/path/to/gem',
      full_name: 'dummy_gem-1.0.0'
    )
  end

  its(:name) { is_expected.to eql 'dummy_gem' }
  its(:full_name) { is_expected.to eql 'dummy_gem-1.0.0' }
  its(:version) { is_expected.to eql '1.0.0' }
  its('path.to_s') { is_expected.to eq '/path/to/gem' }
  its(:path) { is_expected.to be_a Pathname }

  context 'version is a Gem::Version' do
    let(:version) { Gem::Version.new('1.0.0') }

    its(:version) { is_expected.to eql '1.0.0' }
  end
end
