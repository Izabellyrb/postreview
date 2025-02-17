class PostCreatorService
  def initialize(params, user_login, ip)
    @params = params
    @user_login = user_login
    @ip = ip
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by!(login: @user_login)
      post = Post.create!(@params.merge(ip: @ip, user: user))

      { message: { title: post.title, body: post.body, ip: post.ip, created_at: post.created_at, author: user.login },
        status: :created }
    end
  rescue ActiveRecord::RecordInvalid => e
    { message: e.record.errors.full_messages, status: :unprocessable_entity }
  rescue StandardError => e
    { message: I18n.t("activerecord.messages.error", error: e.message), status: :internal_server_error }
  end
end
