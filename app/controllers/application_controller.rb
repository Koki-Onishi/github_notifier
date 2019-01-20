# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def require_login
    redirect_to log_in_path unless logged_in?
  end
end
