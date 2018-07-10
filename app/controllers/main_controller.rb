class MainController < ApplicationController
  def index
    if(request.params['authenticated'] == 'true' || authenticated?) && access_token.present?
      session[:user] = {} if session[:user].nil?
      session[:user][:authenticated] = true
      res = check_wallet
      if res.length > 0
        participant_service = ParticipantService.new(access_token)
        particpant = participant_service.ping
        session[:user].merge!(participant_service.mydetails(particpant['participant']))
      elsif res.empty? || res["error"]
        redirect_to register_path and return
      else
        
      end
    else
      redirect_to signin_path and return
    end
  end

  private

  def check_wallet
    ws = WalletService.new(access_token)
    ws.checkWallet
  end
end