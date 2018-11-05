# frozen_string_literal: true

RSpec.describe BundleHack::GemfileWriter do
  let(:dummy_path) { BundleHack.root.join('spec', 'dummy') }
  let(:gemfile_path) { BundleHack.root.join('spec', 'fixtures', 'Gemfile') }
  let(:gem) do
    BundleHack::Gem.new(
      name: 'dummy_gem',
      version: '1.0.0',
      path: BundleHack.root.join('spec', 'fixtures', 'dummy_gem-1.0.0'),
      full_name: 'dummy_gem-1.0.0'
    )
  end

  let(:gems) { [gem.update(locations: [3])] }

  subject(:gemfile_writer) do
    described_class.new(dummy_path, gemfile_path, gems)
  end

  it { is_expected.to be_a described_class }

  describe '#create' do
    let(:hacked_gemfile_path) { dummy_path.join(BundleHack::GEMFILE) }
    subject(:create) { gemfile_writer.create }

    before(:each) do
      FileUtils.rm_f(hacked_gemfile_path)
    end

    it 'creates hacked Gemfile when not already present' do
      create
      expect(File.exist?(dummy_path.join(BundleHack::GEMFILE))).to be true
    end

    it 'comments existing versions of gems' do
      create
      expect(File.read(hacked_gemfile_path)).to include "# gem 'dummy_gem'"
    end

    it 'includes hash params passed to original gem definitions' do
      create
      expect(
        File.read(hacked_gemfile_path)
      ).to match(/# gem 'dummy_gem'.*:require => false/)
    end

    it 'appends hacked versions of gem' do
      create
      expect(
        File.read(hacked_gemfile_path)
      ).to include "gem 'dummy_gem', path: '#{BundleHack::HACK_DIR}/dummy_gem'"
    end
  end
end
