class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user, only: [ :update, :show, :destory ]

  # GET   /api/v1/users
  def index
    users = MasterUserQuery.instance.get_all_users
    render json: users, status: :ok # (200)
  end

  # POST    /api/v1/users
  def create
    user = MasterUserQuery.instance.create_user
    user.full_name = prod_params[:full_name]
    user.email = prod_params[:email]
    user.password = prod_params[:password]
    user.password_confirmation = prod_params[:password]

    role_name = prod_params[:role_name]

    case role_name.singularize.downcase
    when "admin"
      MasterUserQuery.instance.add_admin(user)
    when "expert"
      MasterUserQuery.instance.add_expert(user)
    else
      MasterUserQuery.instance.add_user(user)
    end

    if user.save
      render json: user, status: :created
    else
      render json: { errors: @user.errors.full_message }, status: :unprocessable_entity # (422)
    end
  end

  # GET   /api/v1/users/{username}
  def show
    if @user
      render json: user, status: :created
    else
      render json: { errors: @user.errors.full_message }, status: :not_found # (404)
    end
  end

  # POST    /api/v1/users/{username}
  def update
    unless @user.update_attributes(prod_params)
      render json: { errors: @user.errors.full_message }, status: :unprocessable_entity # (422)
    end
    endobject = set_user(params[:id])
  end

  # DELETE    /api/v1/users/{username}
  def destroy
    @user
    # TODO: Soft delete
  end

  private

    def prod_params
      params.permit([
        :full_name,
        :email,
        :password,
        :role_name
      ])
    end

    def set_user
      @user = MasterUserQuery.instance.get_user(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: "User not found" }, status: :not_found
    end
end
