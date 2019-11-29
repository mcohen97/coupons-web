class ApplicationKeysService
  include HttpRequests

  GATEWAY_URL = ENV.fetch('GATEWAY_URL'){'https://coupons-gateway.herokuapp.com'}

  def self.instance()
    @instance = @instance || ApplicationKeysService.new()
    return @instance
  end

  def get_application_keys(page = nil, offset = nil)
    route = '/v1/app_keys'
    keys = (get route).data
    keys.map{ |key| build_app_key(key)}
  end

  def get_application_key(token)
    route = '/v1/app_keys/' + token
    result = get route
    if result.success
      build_app_key(result.data)
    end
  end

  def delete_application_key(name)
    route = '/v1/app_keys/' + name
    delete route
  end

  def create_application_key(payload)
    payload[:promotions] =payload[:promotions].select{|id| !id.empty?}.map{ |id| id.to_i}
    route = '/v1/app_keys'
    result = post route, payload
    if result.success
      result.data = build_app_key(result.data)
    end
    return result
  end

  def update_application_key(name, payload)
    payload[:promotions] = payload[:promotions].filter {|p| !p.blank?}.map{|p| p.to_i}
    route = '/v1/app_keys/'+ name
    put route, payload
  end

private

  def initialize
    @connection = create_connection(GATEWAY_URL)
  end
  
  def build_app_key(key)
    args = key.slice('name', 'token')
    promos =  key['promotion_ids'].zip(key['promotion_names'])
                                                 .map {|id, name | Promotion.new(id: id, name: name)}

    ApplicationKey.new(name: key['name'], token: key['token'], promotions: promos, new: false)
  end
end