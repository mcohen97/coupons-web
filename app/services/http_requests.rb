module HttpRequests
  
  @@authorization = ''
  @@token = ''

  def self.setToken(token)
    @@authorization = 'Bearer '+token
    @@token = token
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
    resp = @connection.get url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
    end

    handle_response(resp)
  end

  def post(url, payload)
    print('se va a invocar el url')

    resp = @connection.post url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
      request.body = payload.to_json
    end

    handle_response(resp)
  end

  def put (url, payload)
    print('se va a invocar el url')

    resp = @connection.put url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
      request.body = payload.to_json
    end

    handle_response(resp)
  end

  def delete (url)
    resp = @connection.delete url do |request|
      request.headers["Authorization"] = @@authorization
      request.headers['Content-Type'] = 'application/json'
    end
    puts "RESPONSE #{resp.inspect}"
    puts "BODY #{resp.body}"
    handle_response(resp)
  end

  def handle_response(response)
    if response.success?
      result = response.body.empty? ? {} : (JSON.parse response.body)
      RequestResult.new(true, result)
    else
      result = response.body.empty? ? {} : (JSON.parse response.body)
      RequestResult.new(false, result)
    end
    rescue JSON::ParserError
      result = {error:"There was an error"}
      return RequestResult.new(false, result)
  end

end