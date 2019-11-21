# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def require_login
    redirect_to log_in_path unless logged_in?
  end

  def github_token_valid(github_token)
    # トークンを検証し、トークンが認証されているか、トークンにリポジトリの読み取り権限があるかどうかを確認する
    client = Octokit::Client.new access_token: github_token
    return :valid if client.scopes(github_token).include?('repo')

    :no_repo
  rescue Octokit::Unauthorized
    :invalid
  end
end
