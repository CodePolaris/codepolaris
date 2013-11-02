class ContactMailer < ActionMailer::Base

  default from: "guest@codepolaris.com"

  def contact_email(params)
    @guest = params

    mail(to: 'marcosserpa@gmail.com', from: @guest[:email].present? ? @guest[:email].present? : "guest@codepolaris.com",
         subject: @guest[:subject].present? ? @guest[:subject] : 'Site Contact')
  end

end
