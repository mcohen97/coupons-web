class OrganizationService

    #temporarily against microservice
    GATEWAY_URL = 'https://coupons-auth.herokuapp.com'
    
    
    
    def self.instance()
      @instance = @instance || OrganizationService.new()
      return @instance
    end
    
    def get_(email)
      route= 'v1/users/'+email
      get route, ''
    end
    
    private
    
      def initialize
        @connection = create_connection
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
    
        resp
        #handle_response(resp)
    
      end
    
      def post(url, payload, authorization)
        print('se va a invocar el url')
    
        resp = @connection.post url do |request|
          request.headers["Authorization"] = authorization
          request.headers['Content-Type'] = 'application/json'
          request.body = payload.to_json
        end
    
        return resp
        #handle_response(resp)
      end
    
      def handle_response(response)
        if response.success?
          return JSON.parse response.body
        else
          return JSON.parse response.body     
        end
      end
    
    end