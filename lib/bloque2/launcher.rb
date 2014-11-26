require 'uri'
module Bloque2
  class Launcher
    def initialize
      @spacecrafts = Dir['config/spacecrafts/*.yml']
      @parked, @cruising, @landed = @spacecrafts.dup, [], []
    end

    def retrieve_spacecrafts!
      @cruising, @landed, @parked = [], [], @spacecrafts.dup
    end

    def spacecrafts
      @spacecrafts
    end

    def parked
      @parked
    end

    def pending
      @spacecrafts - @cruising - @landed
    end

    def landed
      @landed
    end

    def launch_spacecraft!
      spacecraft = @parked.shift
      @cruising << spacecraft
      spacecraft
    end
    
    def cruising
      @cruising
    end 

    def just_landed! spacecraft
      if @cruising.include?(spacecraft)
        @landed << @cruising.delete(spacecraft)
      else
        raise ArgumentError, 'Spacecraft not found in space.'
      end
    end
  end
end
