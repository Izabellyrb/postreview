class RatingCreatorService
  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      rating = Rating.create!(@params)

      { message: { average_rating: PostAnalyticsService.post_average_rating(rating.post_id) }, status: :created }
    end
  rescue ActiveRecord::RecordInvalid => e
    { message: e.record.errors.full_messages, status: :unprocessable_entity }
  rescue StandardError => e
    { message: I18n.t("activerecord.messages.error", error: e.message), status: :internal_server_error }
  end
end
