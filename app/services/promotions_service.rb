require_relative '../../lib/error/service_response_error.rb'

class PromotionsService


#temporarily against microservice

GATEWAY_URL = 'https://coupons-evaluation.herokuapp.com'

def self.instance()
  @instance = @instance || PromotionsService.new()
  return @instance
end

def get_promotions(filters, authorization)
  route  = '/v1/promotions'
  if filters.any?
    route += add_filters(filters)
  end
  puts route
  get route, authorization
end


private

  def initialize
    @connection = create_connection
  end

  def add_filters(filters)
    query_string += '?'
    filters.each do |filter, value|
        if query_string == '?'
          query_string += "#{filter}=#{value}"
        else
          query_string += "&#{filter}=#{value}"
        end
    end
  end
  
  def create_connection
    
    conn = Faraday.new(url: GATEWAY_URL) do |c|
      c.response :logger
      c.request :json
      c.use Faraday::Adapter::NetHttp
    end

    return conn
  end

  def get (url, authorization)
    resp = @connection.get url do |request|
      request.headers["Authorization"] = authorization
      request.headers['Content-Type'] = 'application/json'
    end

    handle_response(resp)

  end

  def post(url, payload, authorization)
    print('se va a invocar el url')

    resp = @connection.post url do |request|
      request.headers["Authorization"] = authorization
      request.headers['Content-Type'] = 'application/json'
      request.body = payload.to_json
    end

    handle_response(resp)
  end

  def handle_response(response)
    if response.success?
      return JSON.parse response.body
    else
      raise ServiceResponseError
    end
  end

end