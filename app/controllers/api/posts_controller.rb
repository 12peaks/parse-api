class Api::PostsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    if params[:group_id]
      posts = user.current_team.posts.where(group_id: params[:group_id]).order(created_at: :desc)
    elsif params[:user_id]
      posts = user.current_team.posts.where(user_id: params[:user_id]).order(created_at: :desc)
    else
      posts = user.current_team.posts.order(created_at: :desc)
    end

    render json: posts.as_json(include: {
      user: { only: [:id, :name, :github_image, :avatar_url] },
      group: { only: [:id, :name, :url_slug] },
      comments: { include: { user: { only: [:id, :name, :avatar_url] } } },
      reactions: { only: [:id, :post_id, :emoji_code, :emoji_text, :user_id] }
    })
  end
  
  def create
    user = current_user || api_user
    post = user.posts.new(post_params)
    if post.save
      render json: post
    else
      render json: { error: post.errors.full_messages }, status: :bad_request
    end
  end

  def update
    user = current_user || api_user
    post = user.posts.find_by(id: params[:id])
    
    return render json: { error: "Post not found or not authorized" }, status: :not_found unless post && post.user_id == user.id
    
    if post.update(post_params)
      render json: post
    else
      render json: { error: post.errors.full_messages }, status: :bad_request
    end
  end

  private

  def post_params
    params.require(:post).permit(:group_id, :content, :text_content, :is_pinned)
  end
end