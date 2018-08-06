class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        rememberable user
        redirect_back_or user
      else
        check_account
      end
    else
      flash.now[:danger] = t ".flash_danger"
      render :new
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

  def check_account
    flash[:warning] = t ".flash_warning"
    redirect_to root_path
  end
end
