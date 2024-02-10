class Api::PostsController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    posts = user.current_team.posts.order(created_at: :desc)
    render json: posts.as_json(include: {
      user: { only: [:id, :name, :github_image, :avatar_url] },
      group: { only: [:id, :name, :url_slug] },
      comments: { include: { user: { only: [:id, :name, :avatar_url] } } }
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

  private

  def post_params
    params.require(:post).permit(:group_id, :content, :text_content, :is_pinned)
  end
end