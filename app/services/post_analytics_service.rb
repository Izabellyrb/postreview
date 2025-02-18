class PostAnalyticsService
  RANKING_LIMIT = 5

  def self.post_average_rating(post_id)
    Rating.where(post_id: post_id).average(:value).to_f.round(2)
  end

  def self.post_ranking
    Post.joins(:ratings)
        .select("posts.id", "posts.title", "posts.body")
        .group("posts.id")
        .order(Arel.sql("AVG(ratings.value) DESC"))
        .limit(RANKING_LIMIT)
  end

  def self.recurrent_ips
    Post.joins(:user)
        .select("posts.ip, STRING_AGG(DISTINCT users.login, ', ') AS logins")
        .group("posts.ip")
        .having("COUNT(posts.ip) > 1")
  end
end
