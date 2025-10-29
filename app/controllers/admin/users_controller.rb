class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Utilisateur créé avec succès."
      redirect_to root_path # vers une page de gestion des utilisateurs
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      redirect_to new_admin_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nom, :prenom, :admin)
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Vous n'avez pas les droits pour accéder à cette page."
    end
  end
  
end
