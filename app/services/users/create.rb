class Users::Create
    def initialize(attribute)
        @data = attribute
    end

    def create
        ActiveRecord::Base.transaction do
            confirm_password!
            valid_role!
            create_user_record
        end
    rescue Exception => e
        Rails.logger.error "Exception: #{e.full_message}"
        { success: false, message: "Exception!" }
    end

    private

    def confirm_password!
        unless @data[:password] == @data[:confirm_password]
            raise ArgumentError, "Password Mismatch!"
        end
    end

    def valid_role!
        role_names = [ RoleQuery::ROLE_ADMIN, RoleQuery::ROLE_EXPERT, RoleQuery::ROLE_USER ]
        unless role_names.include?(@data[:role_name])
            raise ArgumentError, "Invalid Role!"
        end
    end

    def create_user_record
        @user = UserQuery.instance.create_user!(
            @data[:email],
            @data[:username],
            @data[:role_name],
            @data[:password]
        )
    end
end
