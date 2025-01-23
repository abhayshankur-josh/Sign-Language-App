class UserQuery
  def get_all_users
    User.all
  end

  def add_user(user)
    User.create!(user)
  end

  def get_user(id)
    User.find(id).first
  end
end
