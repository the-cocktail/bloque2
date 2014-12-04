require 'spec_helper'
include Bloque2

describe DiskDockingPort do
    before :all do
      Launcher.new(:disk).retrieve_spacecrafts! # Let's start from scratch
    end

  before do
    @launcher = Launcher.new(:disk)
    @first_launch = @launcher.launch_spacecraft!
  end

  it 'should persist launchings between different Launching instances' do
    pending, landed = @launcher.pending, @launcher.landed
    just_launched = @launcher.launch_spacecraft!
    launcher2 = Launcher.new(:disk)
    launcher2.cruising.must_include just_launched
    launcher2.pending.size.must_equal pending.size - 1
    launcher2.landed.size.must_equal landed.size
  end
 
  it 'should persist landing reports between different Launching instances' do
    pending, landed = @launcher.pending, @launcher.landed
    score = 77
    @launcher.just_landed! @first_launch, score
    launcher2 = Launcher.new(:disk)
    launcher2.landed.must_include @first_launch
    launcher2.score(@first_launch).must_equal score
    launcher2.pending.size.must_equal pending.size
    launcher2.landed.size.must_equal landed.size + 1
  end
end
