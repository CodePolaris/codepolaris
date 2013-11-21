class ContactMailer < ActionMailer::Base

  default from: "contato@codepolaris.com"

  def contact_email(params)
    @guest = params

    mail(to: 'contato@codepolaris.com; rodrigo@codepolaris.com; julio@codepolaris.com; marcos@codepolaris.com;', from: @guest[:email],
         subject: @guest[:subject].present? ? @guest[:subject] : 'Site Contact')
  end

end
