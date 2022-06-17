# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  def after_sign_in_path_for(_user)
    dashboard_path
  end

  def after_sign_out_path_for(_user)
    root_path
  end

  def guest_sign_in
    admin = Admin.guest
    sign_in admin
    redirect_to dashboard_path, notice: 'guestadminでログインしました。'
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(
      :sign_in, keys: %i[name email password password_confirmation]
    )
  end
end
