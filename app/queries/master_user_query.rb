class MasterUserQuery
  attr_accessor :users

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @users ||= User.all
  end

  def get_all_users
    @users
  end

  def create_user
    User.new
  end

  def add_user(user)
    user.role_id = RoleQuery.instance.get_user_id
    user.save
  end

  def add_expert(user, role_name = "user")
    user.role_id = RoleQuery.instance.get_expert_id
    user.save
  end

  def add_admin(user)
    user.role_id = RoleQuery.instance.get_admin_id
    user.save
  end

  def get_user(id)
    @users.find(id)
  end

  def find_by_email(email)
    @users.find_by_email(email)
  end


  private_class_method :new
end
