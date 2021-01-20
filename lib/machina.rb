class Machina
  def initialize(initial_state)
    @state = initial_state
    @events = Hash.new { |h, k| h[k] = [] }
  end

  def state
    @state
  end

  def trigger(event, *args)
    Array(@events[event][@state]).each do |state|
      @state = state

      self.when[@state].call(*args)
    end

    on[event].call(*args)
  end

  def on
    @on ||= Hash.new { |h, k| h[k] = -> (*args) {} }
  end

  def when
    @when ||= Hash.new { |h, k| h[k] = -> (*args) {} }
  end

  def []=(key, states)
    @events[key] = states
  end
end
