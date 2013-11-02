# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base

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
      redirect_to contact_path, notice: "Em breve entraremos em contato para marcar uma reunião."
    else
      render '/contact_mailer/contact_form'
    end
  end

  def contact_form
    @errors = []
    render '/contact_mailer/contact_form'
  end

  def home
  end

end
