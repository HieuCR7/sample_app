class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      rememberable user
      redirect_to user
    else
      flash_danger
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def rememberable user
    if params[:session][:remember_me] == Settings.sessions.remember_me
      remember user
    else
      forget user
    end
  end

  def flash_danger
    flash.now[:danger] = t ".msg"
    render :new
  end
end
