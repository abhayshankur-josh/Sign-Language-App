class RoleQuery
  attr_reader :roles

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @roles = Role.all
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

  def get_role_id(role_name = "user")
    @roles.find_by(role_name: role_name).id
  end

  def get_role_name(role_id)
    @roles.find(role_id).role_name.humanize
  end

  private_class_method :new
end
