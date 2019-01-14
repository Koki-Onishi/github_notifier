class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    is_token_valid = github_token_valid?
    unless is_token_valid == :true
      if is_token_valid == :no_repo
        flash.now[:warning] = 'アクセストークンのscopeにrepoを入れてください'
        render 'users/new' and return
      elsif is_token_valid == :invalid
        flash.now[:warning] = 'アクセストークンが不正です'
        render 'users/new' and return
      end
    end

    @user.issue_viewed_at = Time.current
    @user.pr_viewed_at = Time.current
    if @user.save
      log_in @user
      redirect_to root_path
    else
      flash.now[:warning] = '入力が不正です'
      render 'users/new'
    end
  end

  def update
    is_token_valid = github_token_valid?
    unless is_token_valid == :true
      if is_token_valid == :no_repo
        flash.now[:warning] = 'アクセストークンのscopeにrepoを入れてください'
        render 'top/edit' and return
      elsif is_token_valid == :invalid
        flash.now[:warning] = 'アクセストークンが不正です'
        render 'top/edit' and return
      end
    end

    if current_user.update(user_params)
      flash[:success] = 'ユーザ情報を変更しました'
      redirect_to root_path
    else
      flash.now[:warning] = '入力が不正です'
      render 'top/edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :github_token)
  end

  def github_token_valid?
    client = Octokit::Client.new access_token: user_params[:github_token]
    return :true if client.scopes(user_params[:github_token]).include?('repo')
    :no_repo
  rescue Octokit::Unauthorized
    :invalid
  end
end
