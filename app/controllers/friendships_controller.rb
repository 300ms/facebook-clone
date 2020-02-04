# frozen_string_literal: true

class FriendshipsController < ApplicationController
  include FriendshipsHelper
  before_action :setup_friends

  def create
    Friendship.request(@user, @friend)
    flash[:notice] = 'Friend request sent.'
    redirect_to root_path
  end

  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.screen_name} accepted!"
    else
      flash[:notice] = "No friendship request from #{@friend.screen_name}."
    end
    redirect_to root_path
  end

  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.screen_name} declined"
    else
      flash[:notice] = "No friendship request from #{@friend.screen_name}."
    end
    redirect_to root_path
  end

  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:notice] = "No request for friendship with #{@friend.screen_name}"
    end
    redirect_to root_path
  end

  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.screen_name} deleted!"
    else
      flash[:notice] = "You aren't friends with #{@friend.screen_name}"
    end
    redirect_to root_path
  end


  private

  def setup_friends
    @user = current_user
    @friend = User.find(params[:friend])
  end
end
