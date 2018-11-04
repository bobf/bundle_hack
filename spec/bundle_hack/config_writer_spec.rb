RSpec.describe BundleHack::ConfigWriter do
  let(:dummy_path) { BundleHack.root.join('spec', 'dummy') }
  let(:config_path) { dummy_path.join('.bundle', 'config') }

  subject(:config_writer) { described_class.new(dummy_path) }

  it { is_expected.to be_a described_class }

  describe '#create_or_update' do
    subject(:create_or_update) { config_writer.create_or_update }

    before { FileUtils.rm_rf(dummy_path.join('.bundle')) }

    it 'creates a new .bundle/config if not already present' do
      create_or_update

      expect(
        YAML.load_file(config_path)
      ).to eql('BUNDLE_GEMFILE' => BundleHack::GEMFILE)
    end

    it 'updates existing .bundle/config' do
      FileUtils.mkdir_p(File.join(dummy_path, '.bundle'))
      File.write(config_path, { 'FOO' => 'bar' }.to_yaml)

      create_or_update

      expect(
        YAML.load_file(config_path)
      ).to eql('BUNDLE_GEMFILE' => BundleHack::GEMFILE, 'FOO' => 'bar')
    end
  end
end
