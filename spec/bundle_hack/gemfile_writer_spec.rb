# frozen_string_literal: true

RSpec.describe BundleHack::GemfileWriter do
  subject(:gemfile_writer) do
    described_class.new(dummy_path, gemfile_path, [gem])
  end

  let(:dummy_path) { BundleHack.root.join('spec', 'dummy') }
  let(:gemfile_path) { BundleHack.root.join('spec', 'fixtures', 'Gemfile') }
  let(:gem) do
    instance_double(
      BundleHack::Gem,
      name: 'dummy_gem',
      version: '1.0.0',
      path: BundleHack.root.join('spec', 'fixtures', 'dummy_gem-1.0.0'),
      full_name: 'dummy_gem-1.0.0',
      locations: [3, 4, 5],
      params: { require: false, git: 'https://example.com/repo.git' }
    )
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

    it 'comments gems at given locations' do
      create
      commented_gem = File.read(
        BundleHack.root.join('spec', 'fixtures', 'commented_gem')
      )
      expect(File.read(hacked_gemfile_path)).to include(commented_gem)
    end

    it 'includes hash params passed to original gem definitions' do
      create
      expect(
        File.read(hacked_gemfile_path)
      ).to match(/^gem 'dummy_gem'.*:require=>false/)
    end

    it 'excludes path-based hash params passed to original gem definitions' do
      create
      expect(
        File.read(hacked_gemfile_path)
      ).to_not match(/^gem 'dummy_gem'.*:git/)
    end

    it 'appends hacked versions of gem' do
      create
      expect(
        File.read(hacked_gemfile_path)
      ).to match(
        %r{^gem 'dummy_gem'.*:path=>"#{BundleHack::HACK_DIR}/dummy_gem"}
      )
    end
  end
end
