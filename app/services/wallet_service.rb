require 'formdata'

class WalletService
  include HTTParty
  base_uri USER_API_BASE_URL

  def initialize(access_token)
    @token = "?access_token="+access_token
  end

  def checkWallet
    res = self.class.get("/wallet#{@token}", {withCredentials: true})
    res
  end
end 