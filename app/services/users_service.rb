require_relative '../../lib/error/service_response_error.rb'


class UsersService
  include HttpRequests

#temporarily against microservice
GATEWAY_URL = 'https://coupons-auth.herokuapp.com'


def self.instance()
  @instance = @instance || UsersService.new()
  return @instance
end

def send_invitation(email_invited, remittent, role, authorization)
  route = '/v1/invitations/'

  post route, {email_invited: email_invited, remittent: remittent, role: role}, authorization
end

def sign_in(email, password)
  route = '/v1/signin/'+ email 

  post route, {password: password}, ''
end

def create_user(userDto)
  route = '/v1/users/'
  body = {
    username: userDto.email,
    password: userDto.password,
    name: userDto.name,
    surname: userDto.surname,
    organization: userDto.org_id,
    role: userDto.role.name,
    invitation_id: userDto.invitation_id
  }

  puts body
  post route, body, ''
end

def get_user(email)
  route= '/v1/users/'+email
  user_data = get route, ''
  return user_data
end



def get_organization(org_id)
  route='/v1/organizations/'+org_id
  org_data = get route, ''
  return org_data
end



private

  def initialize
    @connection = create_connection(GATEWAY_URL)
  end
  
end