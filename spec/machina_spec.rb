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
    Post = Struct.new(:title, :notified)

    post = Post.new("Something HN worthy", false)

    fsm.when[:send_notification] = -> (post) { post.notified = true }

    fsm[:complete] = {
      :start  => [:review, :send_notification, :final],
      :review => [:send_notification, :final],
      :reset  => :start
    }

    assert_equal :start, fsm.state

    fsm.trigger(:complete, post)

    assert_equal :final, fsm.state
    assert_equal true, post.notified
  end
end
