class TopController < ApplicationController
  before_action :require_login
  before_action :set_client, :get_issues, only: [:show, :new_issues]

  def show
    @issues = @assigned_issues
  end

  def new_issues
    new_issue = ''
    new_pull_request = ''
    @assigned_issues.each do |assigned_issue|
      is_new_issue = false
      if assigned_issue.updated_at > current_user.issue_viewed_at
        current_user.update!(issue_viewed_at: Time.current)
        new_issue = assigned_issue.title
        is_new_issue = true
      end
      break if is_new_issue
    end

    @pull_requests.each do |pull_request|
      is_new_pull_request = false
      if pull_request.updated_at > current_user.pr_viewed_at
        current_user.update!(pr_viewed_at: Time.current)
        new_pull_request = pull_request.title
        is_new_pull_request = true
      end
      break if is_new_pull_request
    end

    render json: { result: true, issue: new_issue, pull_request: new_pull_request } and return if new_issue.present? || new_pull_request.present?
    render json: { result: false }
  end

  private

  def set_client
    @client = Octokit::Client.new access_token: current_user.github_token
  end

  def get_issues
    @assigned_issues = @client.search_issues("is:open is:issue assignee:#{@client.login}").items
    @pull_requests = @client.search_issues("is:open is:pr author:#{@client.login}").items
  end
end
