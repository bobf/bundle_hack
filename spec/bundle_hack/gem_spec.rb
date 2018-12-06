# frozen_string_literal: true

RSpec.describe BundleHack::Gem do
  subject(:gem) do
    described_class.new(
      definitions,
      name: 'dummy_gem',
      version: version,
      path: '/path/to/gem',
      full_name: 'dummy_gem-1.0.0'
    )
  end

  let(:definitions) { [] }
  let(:version) { '1.0.0' }

  its(:name) { is_expected.to eql 'dummy_gem' }
  its(:full_name) { is_expected.to eql 'dummy_gem-1.0.0' }
  its(:version) { is_expected.to eql '1.0.0' }
  its('path.to_s') { is_expected.to eq '/path/to/gem' }
  its(:path) { is_expected.to be_a Pathname }

  context 'version is a Gem::Version' do
    let(:version) { Gem::Version.new('1.0.0') }

    its(:version) { is_expected.to eql '1.0.0' }
  end

  describe '#locations' do
    subject(:locations) { gem.locations }
    let(:definitions) { [{ locations: [1, 2] }, { locations: [3, 4] }] }
    it { is_expected.to eql [1, 2, 3, 4] }
  end

  describe '#params' do
    context 'primary group' do
      subject(:params) { gem.params }
      let(:definitions) do
        [
          { group: nil, params: { a: 1 } },
          { group: :development, params: { b: 1 } }
        ]
      end

      it { is_expected.to eql(a: 1) }
    end

    context 'development group' do
      subject(:params) { gem.params }
      let(:definitions) do
        [
          { group: :development, params: { a: 1 } },
          { group: :test, params: { b: 1 } }
        ]
      end

      it { is_expected.to eql(a: 1) }
    end

    context 'any group (use last definition)' do
      subject(:params) { gem.params }
      let(:definitions) do
        [
          { group: :test, params: { b: 1 } },
          { group: :production, params: { a: 1 } }
        ]
      end

      it { is_expected.to eql(a: 1) }
    end
  end
end
