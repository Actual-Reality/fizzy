require "test_helper"

class User::SearcherTest < ActiveSupport::TestCase
  setup do
    @user = users(:kevin)
  end

  test "remember the last search" do
    assert_difference -> { @user.search_queries.count }, +1 do
      @user.remember_search("broken")
    end

    assert_equal "broken", @user.search_queries.last.terms
  end

  test "don't duplicate repeated searches" do
    @user.remember_search("broken")

    assert_no_difference -> { @user.search_queries.count }, +1 do
      @user.remember_search("broken")
    end
  end
end
