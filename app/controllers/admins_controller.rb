class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_admin, only: %i[ show edit update destroy ]

  # GET /admins or /admins.json
  def index
    @admins = MasterUserQuery.instance.get_all_users
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = User.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: "Admin was successfully created." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: "Admin was successfully updated." }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy!

    respond_to do |format|
      format.html { redirect_to admins_path, status: :see_other, notice: "Admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = MasterUserQuery.instance.get_user(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.fetch(:admin, {})
    end
end
