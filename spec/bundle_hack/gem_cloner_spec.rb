RSpec.describe BundleHack::GemCloner do
  let(:root_path) { BundleHack.root.join('spec', 'dummy') }
  let(:gem) do
    BundleHack::Gem.new(
      full_name: 'dummy_gem-1.0.0',
      path:  BundleHack.root.join('spec', 'fixtures', 'dummy_gem-1.0.0'),
      name: 'dummy_gem',
      version: '1.0.0'
    )
  end

  subject(:gem_cloner) { described_class.new(gem, root_path) }

  it { is_expected.to be_a described_class }

  describe '#clone' do
    subject(:clone) { gem_cloner.clone }

    before { FileUtils.rm_rf(root_path.join(BundleHack::HACK_DIR)) }

    it 'copies versioned gem to an unversioned location in hack directory' do
      clone
      expected_file_path = root_path.join(
        BundleHack::HACK_DIR, 'dummy_gem', 'lib', 'dummy_gem.rb'
      )
      expect(File.exist?(expected_file_path)).to be true
    end
  end
end
