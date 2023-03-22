require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new
    user.email = "a@abc.com"
    user.password = "1234567"
    assert_not user.save, "Saved the user without a username"
  end

  test "should save user with email, password and username" do
    user = User.new
    user.email = "a@abc.com"
    user.password = "1234567"
    user.username = "Abi"
    assert user.save
  end
end
