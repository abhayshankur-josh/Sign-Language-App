class RoleQuery
  attr_reader :roles

  ROLE_ADMIN = "admin"
  ROLE_EXPERT = "expert"
  ROLE_USER = "user"

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @roles = Role.all
  end

  def get_admin_id
    @roles.find_by(role_name: ROLE_ADMIN).id
  end

  def get_user_id
    @roles.find_by(role_name: ROLE_USER).id
  end

  def get_expert_id
    @roles.find_by(role_name: ROLE_EXPERT).id
  end

  def get_role_id(role_name = ROLE_USER)
    @roles.find_by(role_name: role_name).id
  end

  def get_role_name(role_id)
    @roles.find(role_id).role_name.humanize
  end

  private_class_method :new
end
