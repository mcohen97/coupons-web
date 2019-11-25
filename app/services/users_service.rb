require_relative '../../lib/error/service_response_error.rb'


class UsersService
  include HttpRequests

#temporarily against microservice
GATEWAY_URL = 'https://coupons-gateway.herokuapp.com'

def self.instance()
  @instance = @instance || UsersService.new()
  return @instance
end

def send_invitation(authorization)
end

def sign_in(email, password)
  route = '/v1/signin/'+ email 

  post route, {password: password}, ''
end

def create_user(invitation_code, payload)
end

private

  def initialize
    @connection = create_connection(GATEWAY_URL)
  end
  
end