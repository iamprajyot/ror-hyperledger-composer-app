class ParticipantService
  include HTTParty
  base_uri USER_API_BASE_URL

  def initialize(access_token)
    @token = "?access_token="+access_token
  end

  def ping
    self.class.get("/system/ping#{@token}", {withCredentials: true})
  end

  def mydetails(participant)
    participant.sub!('#','/')
    self.class.get("/"+participant+"#{@token}", {withCredentials: true})
  end
end 