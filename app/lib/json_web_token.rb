class JsonWebToken
  HMAC_SECRET = ENV["JWT_SECRET"]

  class << self
    def encode payload, exp
      payload[:exp] = exp.to_i
      JWT.encode(payload, HMAC_SECRET)
    end

    def decode token
      body = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new body
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      {
        success: false,
        error: Settings.msg.invalid_access_token,
        message: e.message
      }.with_indifferent_access
    end
  end
end
