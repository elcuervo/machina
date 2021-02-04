# frozen_string_literal: true

class Machina
  InvalidEventError = Class.new(StandardError)
  InvalidStateChangeError = Class.new(StandardError)

  EVENT = -> (h, k) { h[k] = ->(*args) {} }

  attr_reader :state, :events

  # Initializes Machina
  #
  # @param initial_state [Symbol] the initial state of the state machine
  # @return [Machina] the initialized Machina
  #
  def initialize(initial_state)
    @state = initial_state
    @events = Hash.new { |h, k| h[k] = [] }
  end

  # Triggers an event.
  #
  # @param event [Symbol] the event to trigger
  # @param args [Array<Object>] the objects that the callback will receive
  # @return [void]
  #
  def trigger(event, *args)
    return unless trigger?(event)

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

  # Triggers an event and raises on error.
  #
  # @param event [Symbol] the event to trigger
  # @param args [Array<Object>] the objects that the callback will receive
  # @return [void]
  #
  def trigger!(event, *args)
    raise InvalidStateChangeError, "Event #{event} missing #{state} step" unless trigger?(event)

    trigger(event, *args)
  end

  # Checks if an event can be triggered
  #
  # @param event [Symbol] the event to trigger
  # @return [Boolean] the chance posibility
  #
  def trigger?(event)
    raise InvalidEventError, "Event #{event} not found." unless events.key?(event)

    events[event].key?(state)
  end

  # Defines the list of possible callbacks when an event is triggered
  #
  # @return [Hash]
  #
  def on
    @on ||= Hash.new(&EVENT)
  end

  # Defines the list of possible callbacks when a state is reached
  #
  # @return [Hash]
  #
  def when
    @when ||= Hash.new(&EVENT)
  end

  # Defines the list of possible events and their transitions
  #
  # @param key [Symbol] the event name
  # @param states [Hash] the event transitions
  # @return [void]
  #
  def []=(key, states)
    events[key] = states
  end
end
