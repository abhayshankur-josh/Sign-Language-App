class AdminQuery
  # Class-level instance variable to hold the single instance
  @instance = nil

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    admin_id = RoleQuery.instance.get_admin_id
    @admins = User.where(role_id: admin_id)
  end



  private_class_method :new
end
