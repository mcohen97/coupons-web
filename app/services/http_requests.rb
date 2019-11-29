module HttpRequests
  
  @@authorization = ''
  @@token = nil

  def self.set_token(token)
    if not token.nil?
      @@authorization = 'Bearer '+token
      @@token = token
    end
  end

  def self.authorization
    @@authorization
  end

  def self.token
    @@token
  end

  def create_connection(gateway_url)
    conn = Faraday.new(url: gateway_url) do |c|
      c.response :logger
      c.request :json
      c.use Faraday::Adapter::NetHttp
    end

    return conn
  end

  def get (url)
    check_token_validity

    resp = @connection.get url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
    end

    handle_response(resp)
  end

  def post(url, payload)
    check_token_validity

    resp = @connection.post url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
      request.body = payload.to_json
    end

    handle_response(resp)
  end

  def put (url, payload)
    check_token_validity
    
    resp = @connection.put url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
      request.body = payload.to_json
    end

    handle_response(resp)
  end

  def delete (url)
    check_token_validity

    resp = @connection.delete url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
    end

    handle_response(resp)
  end

  def handle_response(response)
    if response.success?
      result = response.body.empty? ? {} : (JSON.parse response.body)
      RequestResult.new(true, result)
    else
      if response.status == 401
        raise UnauthorizedError
      end
      puts 'ERROR REQUEST'
      puts response.body
      result = response.body.empty? ? {} : (JSON.parse response.body)
      RequestResult.new(false, result)
    end
    rescue JSON::ParserError
      result = {error:"There was an error"}
      return RequestResult.new(false, result)
  end

  def check_token_validity
    if not @@token.nil?
      payload = JsonWebToken.decode(@@token)
      actual_time = Time.now.to_i
      if payload['expires'] < actual_time
        raise ExpiredTokenError
      end
    end
  rescue JWT::DecodeError
    raise ExpiredTokenError
  end

end