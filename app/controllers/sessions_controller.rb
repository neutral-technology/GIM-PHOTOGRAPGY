class SessionsController < ApplicationController
  layout 'default'
  def index
    scoped = policy_scope(Receipt)

    # Today sessions
    @receipts = scoped
      .includes(:client, :photographer)
      .where(date: Date.today)
      .order(:created_at)

    # Stats per photographer
    @stats = scoped
      .where(date: Date.today)
      .group(:photographer_id)
      .select(
        "photographer_id,
         COUNT(*) as sessions_count,
         SUM(photos_count) as total_photos"
      )
  end
end