# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base

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

    if @errors.blank?
      ContactMailer.contact_email(params).deliver
      redirect_to home_path, notice: t('message.contact_response')
    else
      render 'home'
    end
  end
  # end mailer

  def home
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

end
