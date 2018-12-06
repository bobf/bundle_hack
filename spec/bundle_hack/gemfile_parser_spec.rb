# frozen_string_literal: true

RSpec.describe BundleHack::GemfileParser do
  let(:gemfile) do
    File.open(BundleHack.root.join('spec', 'fixtures', 'Gemfile'))
  end

  subject(:gemfile_parser) { described_class.new(gemfile) }
  it { is_expected.to be_a described_class }

  describe '#definitions_for' do
    subject(:definitions) { gemfile_parser.definitions_for(gem_name) }

    context 'undefined gem' do
      let(:gem_name) { 'non_existent' }
      subject { proc { definitions } }
      it { is_expected.to raise_error BundleHack::ParsingError }
    end

    describe '[:locations]' do
      subject(:locations) do
        definitions.map { |definition| definition[:locations] }.flatten
      end

      context 'gem: dummy_gem' do
        let(:gem_name) { 'dummy_gem' }
        it { is_expected.to eql [3, 4, 5] }
      end

      context 'gem: noop' do
        let(:gem_name) { 'noop' }
        it { is_expected.to eql [8, 12] }
      end
    end

    describe '[:params]' do
      subject(:params) { definitions.first[:params] }

      let(:gem_name) { 'dummy_gem' }

      its([:require]) { is_expected.to eql false }
      its([:platforms]) { is_expected.to eql %i[mri mingw] }
      its([:git]) do
        is_expected.to eql 'https://github.com/bobf/another_dummy_gem'
      end
    end
  end
end
