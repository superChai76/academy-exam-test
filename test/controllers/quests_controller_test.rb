require "test_helper"

class QuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quest = quests(:one)
  end

  test "should get index" do
    get quests_url
    assert_response :success
  end

  test "should create quest" do
    assert_difference("Quest.count") do
      post quests_url, params: { quest: { content: @quest.content, done: @quest.done, due_date: @quest.due_date, created_at: @quest.created_at, updated_at: @quest.updated_at } }
    end
  end

  test "should destroy quest" do
    assert_difference("Quest.count", -1) do
      delete quest_url(@quest)
    end

    assert_redirected_to quests_url
  end
end
