# frozen_string_literal: true

RSpec.shared_examples 'a gemspec source' do
  let(:gem) do
    BundleHack::Gem.new(
      name: 'dummy_gem',
      version: '1.0.0',
      path: BundleHack.root.join('spec', 'fixtures', 'dummy_gem-1.0.0'),
      full_name: 'dummy_gem-1.0.0'
    )
  end

  subject(:source) { described_class.new(gem) }

  it { is_expected.to be_a described_class }

  describe '#spec' do
    # TODO: Tests are pretty thin here because we test the full functionality in
    # the tests for `GemspecCloner`. This is a result of chronology rather than
    # intent - the tests should be refactored so that each source is tested for
    # its expected behaviours.
    subject(:spec) { proc { source.spec } }
    it { is_expected.to_not raise_error }
  end
end
