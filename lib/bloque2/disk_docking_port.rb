require 'json'

module Bloque2
  class DiskDockingPort
    DOCKING_PORT_FILE = '/tmp/bloque2_docking_port.json'
    def initialize(missions)
      if File.exists?(DOCKING_PORT_FILE)
        read_missions_from_json_file
      else
        reset_docking_port missions
        write_missions_hash missions
      end
    end

    def retrieve_spacecrafts!
      reset_docking_port
      write_missions_hash
    end

    def pending
      read_missions_from_json_file
      @pending
    end

    def cruising
      read_missions_from_json_file
      @cruising
    end

    def landed
      read_missions_from_json_file
      @landed
    end

    def launch_spacecraft!
      read_missions_from_json_file
      if mission = @pending.shift
        @cruising << mission
        @missions_hash[mission] = {score: -2}
        write_missions_hash
        mission
      end
    end

    def just_landed! spacecraft, score = 0
      read_missions_from_json_file
      if @cruising.include?(spacecraft)
        @missions_hash[@cruising.delete(spacecraft)] = {score: score}
        write_missions_hash
      else
        raise ArgumentError, 'Spacecraft not found cruising (already landed?)'
      end
    end

  private
    def missions_hash_ready_to_start(missions = nil)
      missions ||= @missions_hash.keys
      Hash[missions.map {|mission| [mission, {score: -1}]}]
    end

    def write_missions_hash(missions = nil)
      if missions
        missions.each do |mission|
          @missions_hash[mission] = {score: -1}
        end
      end
      File.open(DOCKING_PORT_FILE, 'w') do |json_file|
        json_file.write JSON.pretty_generate(@missions_hash)
      end
    end

    def reset_docking_port(missions=nil)
      @missions_hash = missions_hash_ready_to_start(missions)
      @pending, @cruising, @landed = missions, [], {}
    end

    def read_missions_from_json_file
      @pending, @cruising, @landed = [], [], {}
      @missions_hash = JSON.parse(File.read(DOCKING_PORT_FILE))
      @missions_hash.each do |mission, report|
        case report['score']
          when -1 then @pending << mission
          when -2 then @cruising << mission
        else
          @landed[mission] = report['score']
        end
      end
    end

  end
end
