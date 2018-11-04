require 'fileutils'

RSpec.describe BundleHack::Sandbox do
  let(:gem_name) { 'dummy_gem' }
  let(:dummy_path) { BundleHack.root.join('spec', 'dummy') }
  let(:gemfile_path) { dummy_path.join('Gemfile') }

  subject(:sandbox) { described_class.new(gem_name, gemfile_path) }

  it { is_expected.to be_a described_class }

  describe '#build' do
    subject(:build) { sandbox.build }

    before do
      FileUtils.rm_rf(dummy_path.join('.bundle'))
      FileUtils.rm_rf(dummy_path.join('hack'))
    end

    it 'raises an error if requested gem is not in Gemfile' do
      expect do
        described_class.new('not_present', gemfile_path).build
      end.to raise_error BundleHack::MissingGemError,
                         I18n.t('errors.missing_gem', gem: 'not_present')
    end

    it 'creates Bundler config' do
      build
      expect(File.exist?(dummy_path.join('.bundle', 'config'))).to be true
    end

    it 'creates hacked Gemfile' do
      build
      expect(File.exist?(dummy_path.join(BundleHack::GEMFILE))).to be true
    end

    it 'creates copy of target gem under hack/<gem_name>' do
      build
      expect(File.exist?(dummy_path.join('hack', 'dummy_gem'))).to be true
    end
  end
end
