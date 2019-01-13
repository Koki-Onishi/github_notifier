class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash[:warning] = 'ログイン情報が不正です'
      redirect_to log_in_path
    end
  end

  def destroy
    log_out
    redirect_to log_in_path
  end
end
