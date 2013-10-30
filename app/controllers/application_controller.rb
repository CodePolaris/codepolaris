class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Guest contact email
  def send_contact_email
    ContactMailer.contact_email(params).deliver

    redirect_to '/contact_form', notice: "Thanks for your message!"
  end

  def contact_form
    render '/contact_mailer/contact_form'
  end

end
