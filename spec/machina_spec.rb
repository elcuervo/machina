require "spec_helper"

describe Machina do
  attr_reader :fsm

  before { @fsm = Machina.new(:start) }

  it "basic" do
    fsm[:begin] = { :start => :step1 }

    assert_equal :start, fsm.state

    fsm.trigger(:begin)

    assert_equal :step1, fsm.state
  end

  it "complex" do
    reached_step2 = false

    fsm.on[:step2] = -> { reached_step2 = true }

    fsm[:complex] = {
      :start => [:step1, :step2, :final]
    }

    assert_equal :start, fsm.state

    fsm.trigger(:complex)

    assert_equal :final, fsm.state
    assert_equal true, reached_step2
  end
end
