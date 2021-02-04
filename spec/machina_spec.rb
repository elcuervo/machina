require "spec_helper"


Post = Struct.new(:title, :notified, :published)

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
    post = Post.new("Something HN worthy", false, false)
    completed = false

    fsm.when[:send_notification] = -> (post) { post.notified = true }
    fsm.when[:published] = -> (post) { post.published = true }

    fsm[:complete] = {
      :start  => [:review, :send_notification, :published],
      :review => [:send_notification, :published],
      :reset  => :start
    }

    fsm.on[:complete] = -> (_post) { completed = true }

    assert_equal :start, fsm.state
    assert_equal false, completed
    assert_equal false, post.notified
    assert_equal false, post.published

    fsm.trigger(:complete, post)

    assert_equal :published, fsm.state
    assert_equal true, completed
    assert_equal true, post.notified
    assert_equal true, post.published
  end

  it "stops on error" do
    fsm.when[:stop] = -> { raise }

    fsm[:act] = {
      :start => [:a, :b, :stop, :final]
    }

    fsm.trigger(:act)

    assert_equal :b, fsm.state
  end

  it "trigger!" do
    fsm[:one] = {
      :not_start => :reset
    }

    assert_raises(Machina::InvalidStateChangeError) { fsm.trigger!(:one) }
    assert_raises(Machina::InvalidEventError)       { fsm.trigger!(:two) }

    assert_equal :start, fsm.state
  end
end
