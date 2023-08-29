class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.users.number_of_page)
  end

  def show
    @pagy, @microposts = pagy @user.microposts.newest, items: Settings.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      # log_in @user
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = t("user_created_success")
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      # Handle a successful update.
      flash[:success] = t("user_updated_success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("user_deleted")
    else
      flash[:danger] = t("deleted_fail")
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("user_not_found")
    redirect_to root_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("cannot_edit")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    redirect_to root_path
    flash[:danger] = t("arenot_admin")
  end
end
