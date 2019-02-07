# frozen_string_literal: true

class TopController < ApplicationController
  before_action :require_login
  before_action :issues, only: %i[show]
  before_action :set_client, :issues, only: %i[new_issues]

  def show
    is_token_valid = github_token_valid(current_user.github_token)
    unless is_token_valid == :valid
      if is_token_valid == :no_repo
        flash.now[:warning] = 'アクセストークンのscopeにrepoを入れてください'
        render('top/edit') && return
      elsif is_token_valid == :invalid
        flash.now[:warning] = 'アクセストークンが不正です'
        render('top/edit') && return
      end
    end

    set_client
    issues
  end

  def new_issues
    new_assigned_issue = new_issue(@assigned_issues, 'issue')
    new_pull_request = new_issue(@pull_requests, 'pr')

    render(json: { result: true, issue: new_assigned_issue, pull_request: new_pull_request }) && return if new_assigned_issue.present? || new_pull_request.present?
    render json: { result: false }
  end

  private

  def set_client
    @client = Octokit::Client.new access_token: current_user.github_token
  end

  def new_issue(issues, name_viewed_at)
    # 取得したissueをループで回して、issueのアップデート日時がDBに保存されている最後に見た日時より後であればそのissueのタイトルを返し、DBの値をissueのアップデート日時に更新する
    # issueのアップデート日時はユーザ作成時にユーザ作成時刻で初期化している
    issues.each do |issue|
      is_new_issue = false
      if issue.updated_at > current_user.send("#{name_viewed_at}_viewed_at")
        current_user.update!("#{name_viewed_at}_viewed_at": Time.current)
        is_new_issue = true
      end
      return issue.title if is_new_issue
    end
  end

  def issues
    @assigned_issues = @client.search_issues("is:open is:issue assignee:#{@client.login}").items
    @pull_requests = @client.search_issues("is:open is:pr author:#{@client.login}").items
  end
end
