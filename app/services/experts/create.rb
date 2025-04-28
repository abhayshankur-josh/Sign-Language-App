class Experts::Create
    def initialize(attribute)
        @data = attribute
    end

    def create
        confirm_password!
        create_experts_record
        { success: true, message: @user }
    rescue Exception => e
        Rails.logger.error "Exception: #{e.full_message}"
        { success: false, message: e.message }
    end

    private

    def confirm_password!
        unless @data[:password] == @data[:confirm_password]
            raise ArgumentError, "Password Mismatch!"
        end
    end

    def create_experts_record
        @user = UserQuery.instance.create_user!(
            @data[:email],
            @data[:username],
            RoleQuery::ROLE_EXPERT,
            @data[:password]
        )
    end
end
