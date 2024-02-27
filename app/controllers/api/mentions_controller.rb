class Api::MentionsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def create
    user = current_user || api_user
    mention = Mention.new(mention_params)
    mention.user = user
    if mention.save
      render json: mention
    else
      render json: { error: mention.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    user = current_user || api_user
    mention = Mention.find_by(id: params[:id], user: user)
    if mention
      mention.destroy
      render json: { success: true, message: "Mention deleted" }
    else
      render json: { error: "Mention not found" }, status: :not_found
    end
  end

  private

  def mention_params
    params.require(:mention).permit(:user, :group, :post, :comment, :mentioned_user_id, :group_id, :post_id, :comment_id)
  end
end
