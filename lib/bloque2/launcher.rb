require_relative 'disk_docking_port'
require_relative 'memory_docking_port'
module Bloque2
  class Launcher
    def initialize(persistence = :memory)
      @spacecrafts = Dir['config/missions/*.yml']
      @docking_port = eval(persistence.to_s.capitalize + 'DockingPort').new(@spacecrafts)
    end

    def retrieve_spacecrafts!
      @docking_port.retrieve_spacecrafts!
    end

    def spacecrafts
      @spacecrafts
    end

    def pending
      @docking_port.pending
    end
    
    def cruising
      @docking_port.cruising
    end 

    def landed
      @docking_port.landed.keys
    end

    def launch_spacecraft!
      @docking_port.launch_spacecraft!
    end

    def just_landed! spacecraft, score = 0
      if score < 0 or score > 100 
        raise ArgumentError, 'Landing "score" should be between 0 (worst landing) an 100 (best one!).'
      end
      @docking_port.just_landed! spacecraft, score
    end

    def score spacecraft
      @docking_port.landed[spacecraft]
    end
  end
end
