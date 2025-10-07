class UserIntegrationsController < ApplicationController
  before_action :set_user_integration, only: [:show, :edit, :update, :destroy]

  def index
    @user_integrations = Current.user.user_integrations.order(created_at: :desc)
  end

  def show
  end

  def new
    @user_integration = Current.user.user_integrations.build
  end

  def create
    @user_integration = Current.user.user_integrations.build(user_integration_params)

    if @user_integration.save
      redirect_to @user_integration, notice: "Integration was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user_integration.update(user_integration_params)
      redirect_to @user_integration, notice: "Integration was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_integration.destroy
    redirect_to user_integrations_url, notice: "Integration was successfully removed."
  end

  private

  def set_user_integration
    @user_integration = Current.user.user_integrations.find(params[:id])
  end

  def user_integration_params
    params.require(:user_integration).permit(:integration_type, :external_id, :access_token, :refresh_token, :expires_at, :active, :metadata)
  end
end
