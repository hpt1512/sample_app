class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)

    if user&.authenticate(params.dig(:session, :password))
      handle_authenticated_user(user)
    else
      handle_invalid_credentials
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def handle_authenticated_user user
    if user.activated
      log_in(user)
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_back_or(user)
    else
      handle_inactive_user
    end
  end

  def handle_inactive_user
    flash[:warning] = t("please_active_account")
    redirect_to root_path
  end

  def handle_invalid_credentials
    flash.now[:danger] = t("invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
