class Machina
  def initialize(initial_state)
    @state = initial_state
    @events = Hash.new { |h, k| h[k] = {} }
  end

  def state
    @state
  end

  def trigger(event)
    Array(@events[event][@state]).each do |state|
      @state = state
      on[@state].call
    end
  end

  def on
    @on ||= Hash.new { |h, k| h[k] = -> {} }
  end

  def []=(key, states)
    @events[key] = states
  end
end
