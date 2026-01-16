class ApplicationMailer < ActionMailer::Base
  default from: "onboarding@resend.dev"  # 開発環境用
  layout "mailer"
end
