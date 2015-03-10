# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  helper_method :random_captcha

  before_filter :get_locale

  respond_to :html
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # begin mailer - Guest contact email
  def send_contact_email
    @errors = []
    @errors << :name    if params[:name].blank?
    @errors << :email   if params[:email].match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil?
    @errors << :message if params[:message].blank?
    @errors << :answer  if params[:answer] != params[:expected_answer] 

    if @errors.blank?
      ContactMailer.contact_email(params).deliver
      redirect_to home_path, notice: t('message.contact_response')
    else
      @random_question, @random_anwser = random_captcha
      render 'home'
    end
  end
  # end mailer

  def home
    @random_question, @random_anwser = random_captcha
    @errors = []
  end

  def routing_error
  end

  def set_locale
    if ['en', 'pt-BR'].include?(params[:l])
      session[:locale] = params[:l]
    end
    redirect_to root_path
  end

  def get_locale
    I18n.locale = session[:locale] if session[:locale].present?
  end

  def random_captcha
    random_number_1 = rand(6..10)
    random_number_2 = rand(1..5)
    random_operator = ['*', '+', '-'].sample
    random_question = "#{random_number_1} #{random_operator} #{random_number_2}"
    random_anwser = eval(random_question)
    return random_question, random_anwser
  end
end
