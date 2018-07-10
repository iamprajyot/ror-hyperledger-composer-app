class IdentityManagementService
  include HTTParty
  base_uri ADMIN_API_BASE_URL

  def registerParticipant(data)
    participantClass = COMPOSER_NAMESPACE + '.' + data[:role].split('_').map(&:capitalize).join('')
    participant = {
      "$class": participantClass,
      "employeeId": data[:employeeId],
      "firstName": data[:firstName],
      "lastName": data[:lastName],
      "email": data[:email],
      "role": data[:role]
    }.to_json
    participant_response = self.class.post('/'+participantClass, {:body => participant,
        :headers => { 'Content-Type' => 'application/json' } })
    return 'Error' if participant_response['role'].empty?
    puts '-----> participant created successfully'
    identity = {
      "participant": participantClass +'#' + data[:employeeId],
      "userID": data[:employeeId],
      "options": {}
    }.to_json
    response = self.class.post('/system/identities/issue', { :body => identity, :headers => {'Content-Type' => 'application/json' }})
    response
  end
end