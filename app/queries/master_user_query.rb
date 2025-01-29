class MasterUserQuery
  # Class-level instance variable to hold the single instance
  @instance = nil

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @users = User.all
  end

  def get_all_users
    @users
  end

  def add_user(user, role_name)
    user[:role_id] = RoleQuery.instance.get_role_id(role_name)
    User.create!(user)
  end

  def get_user(id)
    @users.find(id)
  end


  private_class_method :new
end
