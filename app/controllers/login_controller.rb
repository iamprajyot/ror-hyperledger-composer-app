class LoginController < ApplicationController
  
  def signin
  end

  def register
    redirect_to signin_path if !authenticated?
  end

  def create_participant
    identityManagement = IdentityManagementService.new
    begin
      card_data = identityManagement.registerParticipant(participant_params)
      if card_data.body.empty?
        flash[:error] = 'error while issue identity' 
        redirect_to register_path and return
      end
      puts '-----> card issued to participant successfully'
      wallet_service = ImportWalletServiceMulti.new
      response = wallet_service.import(card_data, access_token)
      unless response.kind_of? Net::HTTPSuccess
        flash[:error] = 'error while importing card to wallet' 
        redirect_to register_path and return
      end
      puts '-----> card imported for participant successfully'
      flash[:success] = 'Participant has been successfuly created'
      redirect_to root_path and return
    rescue Exception => e
      flash[:error] = 'error while creating participant'
      puts e
      redirect_to register_path and return
    end
  end

  def signout
    wallet_service = ImportWalletServiceMulti.new
    res = wallet_service.logout
    session.delete(:user)
    cookies.clear
    redirect_to root_path
  end

  private

  def participant_params
    params.permit(:employeeId, :firstName, :lastName, :email, :role)
  end
end
