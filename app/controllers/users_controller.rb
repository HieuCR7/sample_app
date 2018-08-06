class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.users.page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".flash_info"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".flash_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".flash_success"
    else
      flash[:danger] = t ".flash_danger"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_conpirmation
  end

  def logged_in_user
    return true if logged_in?
    store_location
    flash[:danger] = t ".flash_danger"
    redirect_to login_path
  end

  def correct_user
    load_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find params[:id]
  end
end
