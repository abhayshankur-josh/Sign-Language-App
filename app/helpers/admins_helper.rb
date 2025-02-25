module AdminsHelper
    def helper_status_code(status)
        case status
        when "approved"
            "bg-success"
        when "pending"
            "bg-warning"
        when "rejected"
            "bg-danger"
        else
            "bg-info"
        end
    end
end
