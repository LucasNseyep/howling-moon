require "test_helper"

class ThoughtTest < ActiveSupport::TestCase
  test "should not save thought if title and content are empty" do
    thought = Thought.new
    assert_not thought.save, "Saved empty thought"
  end

  test "Should save thought with only the content" do
    thought = Thought.new
    thought.user = User.first
    thought.content = "Thought Content"
    assert thought.save
  end
end
