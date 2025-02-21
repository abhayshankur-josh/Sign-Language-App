class UserQuery
  attr_reader :users

  # Class method to return the single instance
  def self.instance
    @instance ||= new
  end

  def initialize
    @users ||= User.all
  end

  def add_user(user, role_name = RoleQuery.ROLE_USER)
    user[:role_id] = RoleQuery.instance.get_role_id(role_name)
    # User.create!(user)
    user.save!
    user
  rescue StandardError => e
    puts "Error: #{e.full_message}"
  end

  def create_user(email, full_name, role_name, password = "defaultpass")
    user = User.new(email: email, password: password, full_name: full_name)
    add_user(user, role_name)
  rescue StandardError => e
    Rails.logger.warn "LOG WARNING: #{e.full_message}"
  end

  def get_user(id)
    @users.find(id)
  end

  def get_user_id(email)
    user = @users.find_by(email: email)
    user&.id
  rescue Exception => e
    Rails.logger.warn "LOG WARNING: #{e.full_message}"
  end

  private_class_method :new
end
