# frozen_string_literal: true

class Machina
  attr_reader :state

  def initialize(initial_state)
    @state = initial_state
    @events = Hash.new { |h, k| h[k] = [] }
  end

  def trigger(event, *args)
    Array(@events[event][state]).each do |candidate_state|
      begin
        self.when[candidate_state].call(*args)
      rescue StandardError
        break
      end

      @state = candidate_state
    end

    on[event].call(*args)
  end

  def on
    @on ||= Hash.new { |h, k| h[k] = ->(*args) {} }
  end

  def when
    @when ||= Hash.new { |h, k| h[k] = ->(*args) {} }
  end

  def []=(key, states)
    @events[key] = states
  end
end
