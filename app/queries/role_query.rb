class RoleQuery
  # Class-level instance variable to hold the single instance
  @instance = nil

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @roles = Role.all
  end

  def select_all
    @roles
  end

  def get_admin_id
    @roles.find_by(role_name: "admin").id
  end

  def get_user_id
    @roles.find_by(role_name: "user").id
  end

  def get_expert_id
    @roles.find_by(role_name: "expert").id
  end

  private_class_method :new
end
