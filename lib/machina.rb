# frozen_string_literal: true

class Machina
  InvalidEventError = Class.new(StandardError)
  InvalidStateChangeError = Class.new(StandardError)

  attr_reader :state, :events

  def initialize(initial_state)
    @state = initial_state
    @events = Hash.new { |h, k| h[k] = [] }
  end

  def trigger(event, *args)
    return if !trigger?(event)

    Array(events[event][state]).each do |candidate_state|
      begin
        self.when[candidate_state].call(*args)
      rescue StandardError
        break
      end

      @state = candidate_state
    end

    on[event].call(*args)
  end

  def trigger!(event, *args)
    raise InvalidStateChangeError, "Event #{event} missing #{state} step" if !trigger?(event)

    trigger(event, *args)
  end

  def trigger?(event)
    raise InvalidEventError, "Event #{event} not found." if !events.key?(event)

    events[event].key?(state)
  end

  def on
    @on ||= Hash.new { |h, k| h[k] = ->(*args) {} }
  end

  def when
    @when ||= Hash.new { |h, k| h[k] = ->(*args) {} }
  end

  def []=(key, states)
    events[key] = states
  end
end
