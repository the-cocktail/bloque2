require 'uri'
module Bloque2
  class Launcher
    def initialize
      @spacecrafts = Dir['config/spacecrafts/*.yml']
      @parked, @cruising, @landed = @spacecrafts.dup, [], {}
    end

    def retrieve_spacecrafts!
      @cruising, @landed, @parked = [], {}, @spacecrafts.dup
    end

    def spacecrafts
      @spacecrafts
    end

    def parked
      @parked
    end

    def pending
      @spacecrafts - @cruising - @landed.keys
    end

    def landed
      @landed.keys
    end

    def launch_spacecraft!
      spacecraft = @parked.shift
      @cruising << spacecraft
      spacecraft
    end
    
    def cruising
      @cruising
    end 

    def just_landed! spacecraft, score = 0
      if score < 0 or score > 100 
        raise ArgumentError, 'Landing "score" should be between 0 (worst landing) an 100 (best one!).'
      end
      if @cruising.include?(spacecraft)
        @landed[@cruising.delete(spacecraft)] = score
      else
        raise ArgumentError, 'Spacecraft not found in space.'
      end
    end

    def score spacecraft
      @landed[spacecraft]
    end
  end
end
