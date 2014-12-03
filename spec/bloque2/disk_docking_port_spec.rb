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
 
  it 'should persist landing reports between different Launching instances' do
    score = 77
    @launcher.just_landed! @first_launch, score
    launcher2 = Launcher.new(:disk)
    launcher2.landed.must_include @first_launch
    launcher2.score(@first_launch).must_equal score
  end
end
