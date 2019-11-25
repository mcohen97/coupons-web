class ApplicationKeysService
  include HttpRequests

  GATEWAY_URL = 'https://coupons-evaluation.herokuapp.com'

  def self.instance()
    @instance = @instance || ApplicationKeysService.new()
    return @instance
  end

  def get_application_keys(authorization, page = nil, offset = nil)
    route = '/v1/app_keys'
    keys = (get route , authorization).data
    keys.map{ |key| build_app_key(key)}
  end

  def get_application_key(token, authorization)
    route = '/v1/app_keys/' + token
    result = get route , authorization
    if result.success
      build_app_key(result.data)
    end
  end

  def delete_application_key(name, authorization)
    route = '/v1/app_keys/' + name
    delete route, authorization
  end

  def create_application_key(payload, authorization)
    ids  = payload[:promotion_ids]
    payload.delete(:promotion_ids)
    payload[:promotions] =ids.select{|id| !id.empty?}.map{ |id| id.to_i}
    route = '/v1/app_keys'
    result = post route, payload, authorization
    if result.success
      result.data = build_app_key(result.data)
    end
    return result
  end

  def update_application_key(name, payload, authorization)
    route = '/v1/app_keys/'+ name
    put route, payload, authorization
  end

private

  def initialize
    @connection = create_connection(GATEWAY_URL)
  end
  
  def build_app_key(key)
    args = key.slice('name', 'token')
    #puts args.inspect
    #args[:id] = args[:name]
    promos = key['promotions'].map{|id| Promotion.new(id: id, name: 'placeholder')}
    appkey = ApplicationKey.new(name: key['name'], token: key['token'], promotions: promos )
    return appkey
  end
end