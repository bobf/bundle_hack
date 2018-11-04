RSpec.describe BundleHack::GemspecCloner do
  include RubyGemsHelper
  let(:gem) do
    BundleHack::Gem.new(
      full_name: 'dummy_gem-1.0.0',
      path:  BundleHack.root.join('spec', 'fixtures', 'dummy_gem-1.0.0'),
      name: 'dummy_gem',
      version: '1.0.0'
    )
  end

  let(:dummy_path) { BundleHack.root.join('spec', 'dummy') }

  subject(:gemspec_cloner) do
    described_class.new(gem, dummy_path, use_cache: false)
  end

  it { is_expected.to be_a described_class }

  describe '#clone' do
    subject(:clone) { gemspec_cloner.clone }

    let(:gemspec_path) do
      dummy_path.join(BundleHack::HACK_DIR, gem.name, "#{gem.name}.gemspec")
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

    # TODO: Refactor these specs into
    # spec/support/gemspec_sources_shared_examples.rb
    context 'git source' do
      let(:gem) do
        BundleHack::Gem.new(
          name: 'another_dummy_gem',
          version: '1.0.0',
          path: BundleHack.root.join(
            'spec', 'fixtures', 'another_dummy_gem-ed0e5d21f1ff'
          ),
          full_name: 'dummy_gem-1.0.0'
        )
      end

      it 'uses source-provided gemspec' do
        clone
        expect(eval(File.read(gemspec_path))).to be_a Gem::Specification
      end
    end

    context 'using cache' do
      subject(:clone) do
        described_class.new(gem, dummy_path, use_rubygems: false).clone
      end

      before do
        allow(Gem)
          .to receive(:spec_cache_dir)
          .and_return(BundleHack.root.join('spec', 'fixtures', 'cache'))
      end

      it 'fetches gem spec from cache' do
        clone
        expect(eval(File.read(gemspec_path))).to be_a Gem::Specification
      end
    end

    context 'unknown gem' do
      let(:gem) do
        BundleHack::Gem.new(
          full_name: 'unknown_gem-1.0.0',
          path:  '/unknown/gem/path',
          name: 'unknown_gem',
          version: '1.0.0'
        )
      end

      subject { proc { clone } }

      it { is_expected.to raise_error(BundleHack::MissingSpecError ) }
    end
  end
end
