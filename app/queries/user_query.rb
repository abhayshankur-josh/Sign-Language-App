class UserQuery
  def initialize
    user_id = RoleQuery.instance.get_user_id
    @users = User.where(role_id: user_id)
  end

  def get_all_users
    @users
  end

  def add_user(user)
    user[:role_id] = RoleQuery.instance.get_user_id
    User.create!(user)
  end

  def get_user(id)
    @users.find(id).first
  end
end
