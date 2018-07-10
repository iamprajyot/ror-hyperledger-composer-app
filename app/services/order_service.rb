class OrderService
  include HTTParty
  base_uri USER_API_BASE_URL

  def initialize(access_token)
    @token = "?access_token="+access_token
  end

  def placeOrder(data)
    res =self.class.post("/org.synerzip.firstcomposer.PlaceOrder#{@token}", {:body => data.to_json,
        :headers => { 'Content-Type' => 'application/json' },  withCredentials: true})
    res
  end

  def fetchOrders
    res = self.class.get("/org.synerzip.firstcomposer.Order#{@token}", {withCredentials: true})
    res
  end

  def fetchOrderTransactions
    res = self.class.get("/org.synerzip.firstcomposer.PlaceOrder#{@token}", {withCredentials: true})
    res
  end

  def fetchOrderIssuedTransactions
    res = self.class.get("/org.synerzip.firstcomposer.IssueProductAndUpdateOrderStatus#{@token}", {withCredentials: true})
    res
  end
end 