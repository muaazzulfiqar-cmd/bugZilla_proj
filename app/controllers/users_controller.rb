class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @totalusers = User.all
    @users = User.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "You cannot delete your own account."
    else
      @user.destroy
      redirect_to users_path, notice: "User was successfully deleted."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :global_role)
  end

  def require_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end