module Bloque2
  class MemoryDockingPort
    def initialize(missions)
      @missions = missions
      @pending, @cruising, @landed = missions.dup, [], {}
    end

    def retrieve_spacecrafts!
      @cruising, @landed, @pending = [], {}, @missions
    end

    def pending
      @missions - @cruising - @landed.keys
    end

    def cruising
      @cruising
    end

    def landed
      @landed
    end

    def launch_spacecraft!
      if mission = @pending.shift
        @cruising << mission
        mission
      end
    end

    def just_landed! spacecraft, score = 0
      if @cruising.include?(spacecraft)
        @landed[@cruising.delete(spacecraft)] = {'score' => score}
      else
        raise ArgumentError, 'Spacecraft not found cruising (already landed?)'
      end
    end
  end
end
