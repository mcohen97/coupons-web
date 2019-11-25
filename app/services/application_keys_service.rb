class ApplicationKeysService
  include HttpRequests

  GATEWAY_URL = 'https://coupons-evaluation.herokuapp.com'

  def self.instance()
    @instance = @instance || ApplicationKeysService.new()
    return @instance
  end

  def get_application_keys(authorization, page = nil, offset = nil)
    route = '/v1/app_keys'
    get route , authorization
  end

  def get_application_key(name, authorization)
    route = '/v1/app_keys/' + name
    get route , authorization
  end

  def delete_key(name, authorization)
    route = '/v1/app_keys/' + name
    delete route, authorization
  end

  def create_key(payload, authorization)
    route = '/v1/app_keys'
    post route, payload, authorization
  end

  def update_key(name, payload, authorization)
    route = '/v1/app_keys/'+ name
    put route, payload, authorization
  end
end