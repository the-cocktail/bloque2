require 'bunny'
require 'json'

module Bloque2
  class RabbitmqDockingPort
    CRUISING_QUEUE = "bloque2_cruising_#{ENV['bloque2_env']}queue"
    LANDED_QUEUE = "bloque2_landed_#{ENV['bloque2_env']}queue"

    def initialize(missions)
      @spacecrafts = missions
      @conn = Bunny.new
      @conn.start
      @channel = @conn.create_channel
    end

    def close_rabbitmq
      @conn.close
    end

    def retrieve_spacecrafts!
      # Pop and ignore current cruising and landed missions
      read_missions_from_rabbitmq
      @cruising, @landed = [], {}
    end


    def pending
      read_missions_from_rabbitmq
      @pending
    end

    def cruising
      read_missions_from_rabbitmq
      @cruising
    end

    def landed
      read_missions_from_rabbitmq
      @landed
    end


    def launch_spacecraft!
      read_missions_from_rabbitmq
      if mission = @pending.shift
        q = @channel.queue(CRUISING_QUEUE)
        @channel.default_exchange.publish(mission, :routing_key => q.name)
        mission
      end
    end

    def just_landed! spacecraft, score = 0
      read_missions_from_rabbitmq
      if @cruising.include?(spacecraft)
        q = @channel.queue(LANDED_QUEUE)
        @channel.default_exchange.publish({spacecraft => {'score'=>score}}.to_json, :routing_key => q.name)
      else
        raise ArgumentError, 'Spacecraft not found cruising (already landed?)'
      end
    end

  private
    def read_missions_from_rabbitmq
      read_cruising_from_rabbitmq
      read_landed_from_rabbitmq
      @pending = @spacecrafts - @cruising - @landed.keys
    end

    def read_cruising_from_rabbitmq
      @cruising ||= []
      q = @channel.queue(CRUISING_QUEUE)
      begin
        delivery_info, properties, payload = q.pop
        @cruising << payload if payload
      end while payload
      @cruising
    end

    def read_landed_from_rabbitmq
      @landed ||= {}
      q = @channel.queue(LANDED_QUEUE)
      begin
        delivery_info, properties, payload = q.pop
        if payload
          @landed.merge! JSON.parse(payload)
        end
      end while payload
      @landed
    end

  end
end
