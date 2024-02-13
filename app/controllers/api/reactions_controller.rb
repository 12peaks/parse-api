class Api::ReactionsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def create
    user = current_user || api_user
    reaction = Reaction.new(reaction_params)
    reaction.user = current_user || api_user

    if params[:post_id]
      post = Post.find(params[:post_id])
      reaction.post = post
      if reaction.save
        render json: reaction
      else
        render json: { error: reaction.errors.full_messages }, status: :bad_request
      end
    else
      if reaction.save
        render json: reaction
      else
        render json: { error: reaction.errors.full_messages }, status: :bad_request
      end
    end
  end

  def update
    reaction = Reaction.find(params[:id])
    if reaction.update(reaction_params)
      render json: reaction
    else
      render json: { error: reaction.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    reaction = Reaction.find(params[:id])
    reaction.destroy
    render json: { success: true, message: "Reaction deleted" }
  end

  private

  def reaction_params
    params.require(:reaction).permit(:emoji_code, :emoji_text, :post_id)
  end
end
