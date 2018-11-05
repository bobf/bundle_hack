# frozen_string_literal: true

RSpec.describe BundleHack::GemfileParser do
  let(:gemfile) do
    File.open(BundleHack.root.join('spec', 'fixtures', 'Gemfile'))
  end

  subject(:gemfile_parser) { described_class.new(gemfile) }
  it { is_expected.to be_a described_class }

  describe '#definition_for' do
    subject(:definition_for) { gemfile_parser.definition_for(gem_name) }

    context 'gem: dummy_gem' do
      let(:gem_name) { 'dummy_gem' }
      let(:path) { '/path/to/dummy_gem' }
      its([:locations]) { is_expected.to eql [3] }
    end

    context 'gem: noop' do
      let(:gem_name) { 'noop' }
      let(:path) { '/path/to/noop' }
      its([:locations]) { is_expected.to eql [6, 10] }
    end

    context 'gem: non_existent' do
      let(:gem_name) { 'non_existent' }
      subject { proc { definition_for } }
      it { is_expected.to raise_error BundleHack::ParsingError }
    end
  end
end
