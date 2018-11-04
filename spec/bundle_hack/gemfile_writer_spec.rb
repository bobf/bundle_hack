RSpec.describe BundleHack::GemfileWriter do
  let(:dummy_path) { BundleHack.root.join('spec', 'dummy') }
  let(:gemfile_path) { BundleHack.root.join('spec', 'fixtures', 'Gemfile') }
  let(:options) { { comment_lines: [3], hacked_gems: ['dummy_gem'] } }

  subject(:gemfile_writer) do
    described_class.new(dummy_path, gemfile_path, options)
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

    it 'appends hacked versions of gem' do
      create
      expect(
        File.read(hacked_gemfile_path)
      ).to include "gem 'dummy_gem', path: '#{BundleHack::HACK_DIR}/dummy_gem'"
    end
  end
end
