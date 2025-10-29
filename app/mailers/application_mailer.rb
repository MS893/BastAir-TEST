class ApplicationMailer < ActionMailer::Base
  default from: ENV["FREE_EMAIL_USER"]
#  default from: "no-reply@monsite.fr"
  layout "mailer"
end
