RSpec.describe BundleHack::GemspecCloner do
  include RubyGemsHelper

  let(:gem) do
    {
      name: 'dummy_gem',
      version: '1.0.0',
      path: BundleHack.root.join('spec', 'fixtures', 'dummy_gem-1.0.0')
    }
  end

  let(:dummy_path) { BundleHack.root.join('spec', 'dummy') }

  subject(:gemspec_cloner) { described_class.new(gem, dummy_path) }

  it { is_expected.to be_a described_class }

  describe '#clone' do
    subject(:clone) { gemspec_cloner.clone }

    let(:gemspec_path) do
      dummy_path.join(BundleHack::HACK_DIR, gem[:name], "#{gem[:name]}.gemspec")
    end

    before do
      FileUtils.rm_rf(dummy_path.join(BundleHack::HACK_DIR))
      stub_rubygems
    end

    it 'fetches a Gemspec and writes it to the hacked gem directory' do
      clone
      expect(File.exist?(gemspec_path)).to be true
    end

    it 'creates a valid .gemspec file' do
      clone
      expect(eval(File.read(gemspec_path))).to be_a Gem::Specification
    end

    context 'git source' do
      let(:gem) do
        {
          name: 'another_dummy_gem',
          version: '1.0.0',
          path: BundleHack.root.join(
            'spec', 'fixtures', 'another_dummy_gem-ed0e5d21f1ff'
          )
        }
      end

      it 'uses source-provided gemspec' do
        clone
        expect(eval(File.read(gemspec_path))).to be_a Gem::Specification
      end
    end
  end
end
