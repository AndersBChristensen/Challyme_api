require 'test_helper'
module Api
  class ChallengesControllerTest < ActionController::TestCase
    setup do
      @challenge = challenges(:one)
      @user = users(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:challenges)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create challenge" do
      assert_difference('Challenge.count') do
        post :create, challenge: {}
      end

      assert_redirected_to challenge_path(assigns(:challenge))
    end

    test "should create challenge with receivers" do
      resp = nil
      assert_difference('Challenge.count') do
        challenge_data = {
            title: "Something",
            tasks_attributes: [
                {
                    title: "Task 1"
                },
                {
                    title: "Task 2",

                }
            ]
        }
        resp = post 'create_with_receivers', format: :json, challenge: challenge_data, receiver_ids: [@user.id]
      end

      assert_response :created
      data = JSON.parse(@response.body)
      assert_equal "Something", data["title"]
      assert_equal "Task 1", data["tasks"][0]["title"]
      assert_equal "Task 2", data["tasks"][1]["title"]

      invites = Invite.where(challenge_id: data["id"])
      assert_not_empty invites
      assert_equal invites[0].user_id, @user.id
    end


    test "should show challenge" do
      get :show, id: @challenge
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @challenge
      assert_response :success
    end

    test "should update challenge" do
      patch :update, id: @challenge, challenge: {}
      assert_redirected_to challenge_path(assigns(:challenge))
    end

    test "should destroy challenge" do
      assert_difference('Challenge.count', -1) do
        delete :destroy, id: @challenge
      end

      assert_redirected_to challenges_path
    end
  end
end