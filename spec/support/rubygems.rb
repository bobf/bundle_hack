# frozen_string_literal: true

module RubyGemsHelper
  def stub_rubygems
    # `specs.4.8.gz` has been manually unpacked from the original version (i.e.
    # gunzipped and un-Marshal'ed), then limited to just the one entry for
    # `dummy_gem` and then re-packed. This avoids having to store the entire
    # specs.4.8.gz (which is pretty huge) as a fixture.
    specs_body = File.read(
      BundleHack.root.join('spec', 'fixtures', 'specs.4.8.gz')
    )
    stub_request(:get, 'https://api.rubygems.org/specs.4.8.gz')
      .to_return(body: specs_body)
  end
end
