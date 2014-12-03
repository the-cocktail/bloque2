require 'spec_helper'
include Bloque2

describe Launcher do
  it 'should have available missions defined in the config/missions directory' do
    Dir['config/missions/*.yml'].size.must_be :>, 0
  end
end
