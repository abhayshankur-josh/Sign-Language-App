module JsonWebToken
    def self.encode(payload, exp = 24.hours.from_now)
        JWT.encode(payload, JWT_SECRET_KEY)
    end

    def self.decode(token)
        body = JWT.decode(token, JWT_SECRET_KEY)[0]
        HashWithIndifferentAccess.new body
    rescue
        nil
    end
end
