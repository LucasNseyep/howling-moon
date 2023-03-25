require "test_helper"

class CollectionTest < ActiveSupport::TestCase
  test "should not save collection if no title" do
    collection = Collection.new
    assert_not collection.save, "Saved empty collection"
  end

  test "should save set user to when collection has a thought" do
    user = User.first

    collection = Collection.new
    collection.title = "Test Collection"
    collection.save

    thought = Thought.new
    thought.title = "Thought Title"
    thought.user = user

    thought.collection = collection
    thought.save

    assert_equal collection, user.collections.last, "Saved empty collection"
  end
end
