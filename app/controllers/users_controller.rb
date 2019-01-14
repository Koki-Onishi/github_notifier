class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.issue_viewed_at = Time.current
    @user.pr_viewed_at = Time.current
    if @user.save
      log_in @user
      redirect_to root_path
    else
      flash[:warning] = '入力が不正です'
      redirect_to sign_up_path
    end
  end

  def update
    if  current_user.update(user_params)
      flash[:success] = 'ユーザ情報を変更しました'
      redirect_to root_path
    else
      flash[:warning] = '入力が不正です'
      redirect_to edit_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :github_token)
  end
end
