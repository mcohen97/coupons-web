require_relative '../../lib/error/service_response_error.rb'

class PromotionsService

def initialize
  @connection = create_connection
end

def evaluate(promotion_code, parameters, authorization)
  post '/promotions/evaluate', {code: promotion_code, attributes: parameters}, authorization
end


private
  
  def create_connection
    #Faraday.new(url: Cms::PUBLIC_WEBSITE_URL)
    
    conn = Faraday.new(url: 'http://localhost:5000') do |c|
      c.response :logger
      c.request :json
      c.use Faraday::Adapter::NetHttp
    end

    return conn
  end

  def post(url, payload, authorization)
    print('se va a invocar el url')

    resp = @connection.post url do |request|
      request.headers["Authorization"] = authorization
      request.headers['Content-Type'] = 'application/json'
      request.body = payload.to_json
    end

    #if resp.success?
    return JSON.parse resp.body
    #else
    #  raise ServiceResponseError
    #end
  end

end