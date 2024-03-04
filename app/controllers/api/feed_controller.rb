class Api::FeedController < ApplicationController
  include ApiAuthentication
  before_action :authenticate_user!, unless: :api_request?
  skip_forgery_protection

  def index
    user = current_user || api_user
    combined_feed = user.current_team.polls.order(created_at: :desc).limit(20) + user.current_team.posts.order(created_at: :desc).limit(20)
    combined_feed.sort_by!(&:created_at).reverse!
    feed_items = combined_feed.map do |item|
      if item.is_a?(Poll)
        item_hash = item.as_json(include: {
                                   poll_options: { include: { poll_votes: { include: { user: { only: [:id],
                                                                                               methods: [:avatar_image_url] } } } } }, user: { only: %i[id name], methods: [:avatar_image_url] }
                                 })
        item_hash.merge!({ type: 'poll' })
      elsif item.is_a?(Post)
        item_hash = item.as_json(include: {
                                   user: { only: %i[id name github_image], methods: [:avatar_image_url] },
                                   group: { only: %i[id name url_slug] },
                                   comments: { include: { user: { only: %i[id name], methods: [:avatar_image_url] } } },
                                   reactions: { only: %i[id post_id emoji_code emoji_text user_id] }
                                 })
        item_hash.merge!({ type: 'post' })
      end
    end
    render json: feed_items
  end
end

