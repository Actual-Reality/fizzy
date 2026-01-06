require "test_helper"

class Search::StemmerTest < ActiveSupport::TestCase
  test "stem single word" do
    result = Search::Stemmer.stem("running")

    assert_equal "run", result
  end

  test "stem multiple words" do
    result = Search::Stemmer.stem("test, running      JUMPING & walking")

    assert_equal "test run jump walk", result
  end

  test "preserve Chinese characters" do
    result = Search::Stemmer.stem("测试")

    assert_equal "测试", result
  end

  test "preserve Japanese characters" do
    result = Search::Stemmer.stem("テスト")

    assert_equal "テスト", result
  end

  test "preserve Korean characters" do
    result = Search::Stemmer.stem("테스트")

    assert_equal "테스트", result
  end

  test "mixed CJK and English" do
    result = Search::Stemmer.stem("running 测试 test")

    assert_equal "run 测试 test", result
  end

  test "mixed CJK and English without spaces" do
    result = Search::Stemmer.stem("hello世界test")

    assert_equal "hello 世界 test", result
  end

  test "CJK punctuation is treated as separator" do
    result = Search::Stemmer.stem("你好。世界")

    assert_equal "你好 世界", result
  end
end
