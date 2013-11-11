# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base

  before_filter :set_locale

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

    session[:errors] = @errors
    if @errors.blank?
      ContactMailer.contact_email(params).deliver
      redirect_to '#contact_form', notice: t('message.contact_response')
    else
      redirect_to '#contact_form'
    end
  end

  def contact_form
    @errors = []
    render '#contact_form'
  end
  # end mailer

  def home
  end

  def routing_error
  end

  def set_locale
    if ['en', 'pt-BR'].include?(params[:l])
      I18n.locale = params[:l]
    else
      I18n.locale = I18n.default_locale
    end
  end

end
