class SessionsController < ApplicationController
  def new; end

  def create
    # byebug
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate(params.dig(:session, :password))
      if user.activated
        # set user_id vao session
        log_in user
        if params.dig(:session,
                      :remember_me) == "1"
          remember(user)
        else
          forget(user)
        end
        redirect_back_or user
      else
        flash[:warning] = t("please_active_account")
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
