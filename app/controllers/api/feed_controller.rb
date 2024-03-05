class Api::FeedController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user

    polls = filter_items(user.current_team.polls, params[:group_id],
                         params[:user_id]).order(created_at: :desc)
    posts = filter_items(user.current_team.posts, params[:group_id],
                         params[:user_id]).order(created_at: :desc)

    combined_feed = (polls + posts).sort_by(&:created_at).reverse!
    feed_items = combined_feed.map do |item|
      item_hash = prepare_item_hash(item)
      item_hash.merge!({ type: item.is_a?(Poll) ? 'poll' : 'post' })
    end

    render json: feed_items
  end

  private

  def filter_items(scope, group_id, user_id)
    scope = scope.where(group_id:) if group_id.present?
    scope = scope.where(user_id:) if user_id.present?
    scope
  end

  def prepare_item_hash(item)
    if item.is_a?(Poll)
      item.as_json(include: {
                     poll_options: { include: { poll_votes: { include: { user: { only: [:id],
                                                                                 methods: [:avatar_image_url] } } } } },
                     user: { only: %i[id name], methods: [:avatar_image_url] }
                   })
    elsif item.is_a?(Post)
      item.as_json(include: {
                     user: { only: %i[id name github_image], methods: [:avatar_image_url] },
                     group: { only: %i[id name url_slug] },
                     comments: { include: { user: { only: %i[id name], methods: [:avatar_image_url] } } },
                     reactions: { only: %i[id post_id emoji_code emoji_text user_id] }
                   })
    end
  end
end
