# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    is_token_valid = github_token_valid?
    unless is_token_valid == :valid
      if is_token_valid == :no_repo
        flash.now[:warning] = 'アクセストークンのscopeにrepoを入れてください'
        render('users/new') && return
      elsif is_token_valid == :invalid
        flash.now[:warning] = 'アクセストークンが不正です'
        render('users/new') && return
      end
    end

    # issueのアップデート日時との比較用に現在時刻でDBを初期化する
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
    unless is_token_valid == :valid
      if is_token_valid == :no_repo
        flash.now[:warning] = 'アクセストークンのscopeにrepoを入れてください'
        render('top/edit') && return
      elsif is_token_valid == :invalid
        flash.now[:warning] = 'アクセストークンが不正です'
        render('top/edit') && return
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
    # トークンを検証し、トークンが認証されているか、トークンにリポジトリの読み取り権限があるかどうかを確認する
    client = Octokit::Client.new access_token: user_params[:github_token]
    return :valid if client.scopes(user_params[:github_token]).include?('repo')

    :no_repo
  rescue Octokit::Unauthorized
    :invalid
  end
end
