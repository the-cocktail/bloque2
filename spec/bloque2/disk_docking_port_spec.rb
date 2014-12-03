require 'spec_helper'
include Bloque2

describe DiskDockingPort do
  before do
    @launcher = Launcher.new(:disk)
    @first_launch = @launcher.launch_spacecraft!
  end

  it 'should persist launchings between different Launching instances' do
    just_launched = @launcher.launch_spacecraft!
    launcher2 = Launcher.new(:disk)
    launcher2.cruising.must_include just_launched
  end
 
end
