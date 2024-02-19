class Api::CommentsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection
  
  def create
    user = current_user || api_user
    comment = Comment.new(comment_params)
    comment.user = current_user || api_user

    if params[:post_id]
      post = Post.find(params[:post_id])
      comment.post = post
      if comment.save
        render json: comment
      else
        render json: { error: comment.errors.full_messages }, status: :bad_request
      end
    else
      if comment.save
        render json: comment
      else
        render json: { error: comment.errors.full_messages }, status: :bad_request
      end
    end
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comment_params)
      render json: comment
    else
      render json: { error: comment.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    render json: { success: true, message: "Comment deleted" }
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
