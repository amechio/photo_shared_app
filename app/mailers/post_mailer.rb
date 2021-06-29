class PostMailer < ApplicationMailer
  def post_mail(post)
    @post = post
    mail to: "ametio.145@gmail.com", subject: "インスタクローンの投稿確認メール"
  end
end
