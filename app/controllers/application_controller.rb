class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # begin mailer - Guest contact email
  def send_contact_email
    ContactMailer.contact_email(params).deliver

    redirect_to '/contact_form', notice: "Thanks for your message!"
  end

  def index
  end

  def contact_form
    render '/contact_mailer/contact_form'
  end
  # end mailer

  def home
    render '/static/home'
  end

  def about
    render '/static/about'
  end

  def services
    render '/static/services'
  end

  def portfolio
    render '/static/portfolio'
  end

end
