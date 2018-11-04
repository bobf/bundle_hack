RSpec.describe BundleHack::GemLocator do
  let(:dummy_app_path) { BundleHack.root.join('spec', 'dummy') }
  let(:gemfile_path) { dummy_app_path.join('Gemfile') }
  let(:gemfile_lock_path) { dummy_app_path.join('Gemfile.lock') }

  subject(:gemfile_parser) do
    described_class.new(gemfile_path, gemfile_lock_path)
  end

  it { is_expected.to be_a described_class }

  describe '#locate' do
    subject(:locate) { gemfile_parser.locate(gem_name) }

    context '(Gemfile) gem: dummy_gem' do
      let(:gem_name) { 'dummy_gem' }

      its([:path]) { is_expected.to end_with 'gems/dummy_gem-1.0.0' }
      its([:name]) { is_expected.to eql 'dummy_gem' }
      its([:full_name]) { is_expected.to eql 'dummy_gem-1.0.0' }
    end

    context '(gemspec) gem: noop' do
      let(:gem_name) { 'noop' }

      its([:path]) { is_expected.to end_with 'gems/noop-0.0.2' }
      its([:name]) { is_expected.to eql 'noop' }
      its([:full_name]) { is_expected.to eql 'noop-0.0.2' }
    end
  end
end
