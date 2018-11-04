RSpec.describe BundleHack::GemCloner do
  let(:root_path) { BundleHack.root.join('spec', 'dummy') }
  let(:gem_name) { 'dummy_gem' }
  let(:gem_full_name) { 'dummy_gem-1.0.0' }
  let(:gem_path) { BundleHack.root.join('spec', 'fixtures', gem_full_name) }
  let(:gem) do
    {
      full_name: gem_full_name,
      path: gem_path,
      name: gem_name
    }
  end

  subject(:gem_cloner) { described_class.new(gem, root_path) }

  it { is_expected.to be_a described_class }

  describe '#clone' do
    subject(:clone) { gem_cloner.clone }

    before { FileUtils.rm_rf(root_path.join('hack')) }

    it 'copies versioned gem to an unversioned location in hack directory' do
      clone
      expect(
        File.exist?(root_path.join('hack', 'dummy_gem', 'lib', 'dummy_gem.rb'))
      ).to be true
    end
  end
end
