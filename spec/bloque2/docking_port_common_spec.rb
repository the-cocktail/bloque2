require 'spec_helper'
include Bloque2

[:memory, :disk, :rabbitmq].each do |dock_type|
  describe "#{dock_type.capitalize}DockingPort" do
    before do
      @launcher = Launcher.new(dock_type)
    end
  
    it 'should have as many spacecrafts as YAML files in the missions directory' do
      @launcher.spacecrafts.size.must_equal Dir['config/missions/*.yml'].size
    end
   
    it 'all spacecrafts should be pending, cruising or landed' do
      (@launcher.spacecrafts - @launcher.pending - @launcher.cruising - @launcher.landed).must_equal []
    end

    it '#launch_spacecraft! should launch one spacecraft and return its filename' do
      pending, cruising = @launcher.pending.size, @launcher.cruising.size
      assert File.exist?(@launcher.launch_spacecraft!)
      @launcher.pending.size.must_equal pending - 1
      @launcher.cruising.size.must_equal cruising + 1
    end
   
    it 'after retrieval #pending should return all the spacecrafts' do
      @launcher.retrieve_spacecrafts!
      @launcher.pending.size.must_equal @launcher.spacecrafts.size
      @launcher.cruising.size.must_equal 0
    end
   
    describe 'Landing' do
      before do
        @launcher.retrieve_spacecrafts!
        @spacecraft = @launcher.launch_spacecraft!
      end
   
      it '#just_landed! should let us land a spacecraft (by default with the worst score)' do
        @launcher.just_landed! @spacecraft
        @launcher.landed.must_include @spacecraft
        @launcher.score(@spacecraft).must_equal 0
      end
     
      it '#just_landed! spacecraft should raise an error if the spacecraft does not exist' do
        proc {
          @launcher.just_landed!('config/space_stars/sun.yml')
        }.must_raise ArgumentError
      end
  
      it '#just_landed! should accept and store a landing score for the spacecraft' do
        @launcher.just_landed! @spacecraft, 97
        @launcher.score(@spacecraft).must_equal 97
      end
  
      it '#just_landed! should raise an exception if the score given is bigger than 100' do
        proc {
          @launcher.just_landed! @spacecraft, 101
        }.must_raise ArgumentError
      end
  
      it '#just_landed! should raise an exception if the score given is less than 0' do
        proc {
          @launcher.just_landed! @spacecraft, -1
        }.must_raise ArgumentError
      end
    end
  end
end
