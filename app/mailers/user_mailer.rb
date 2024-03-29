class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mail.account_activation.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mail.password_reset.password_reset")
  end
end
