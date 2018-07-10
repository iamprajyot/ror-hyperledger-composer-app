class ProductService
  include HTTParty
  base_uri USER_API_BASE_URL

  def initialize(access_token)
    @token = "?access_token="+access_token
  end

  def create(data)
    res =self.class.post("/org.synerzip.firstcomposer.Product#{@token}", {:body => data.to_json,
        :headers => { 'Content-Type' => 'application/json' },  withCredentials: true})
    res
  end

  def all
    res = self.class.get("/org.synerzip.firstcomposer.Product#{@token}", {withCredentials: true})
    res
  end

  def findOne(id)
    res = self.class.get("/org.synerzip.firstcomposer.Product/#{id}#{@token}", {withCredentials: true})
    res
  end

  def exists?(id)
    res = self.class.head("/org.synerzip.firstcomposer.Product/#{id}#{@token}", {withCredentials: true})
    res
  end

  def update(data)
    res = self.class.put("/org.synerzip.firstcomposer.Product/#{data['id']}#{@token}", {:body => data.to_json,
        :headers => { 'Content-Type' => 'application/json' },  withCredentials: true})
    res
  end

  def delete(id)
    res = self.class.delete("/org.synerzip.firstcomposer.Product/#{id}#{@token}", {withCredentials: true})
    res
  end

  def issue(data)
    res =self.class.post("/org.synerzip.firstcomposer.IssueProductAndUpdateOrderStatus#{@token}", {:body => data.to_json,
        :headers => { 'Content-Type' => 'application/json' },  withCredentials: true})
    res
  end
end 