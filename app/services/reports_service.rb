class ReportsService
    include HttpRequests
  
  #temporarily against microservice
  GATEWAY_URL = 'https://coupons-gateway.herokuapp.com'
  
  
  def self.instance()
    @instance = @instance || ReportsService.new()
    return @instance
  end
  
  def get_demographic_report(promotion_id)
    route = '/v1/reports/demographic/'+promotion_id
    get route
  end
  
  def get_usage_report(promotion_id)
    route = '/v1/reports/usage/'+promotion_id
    get route
  end
  
  private
  
    def initialize
      @connection = create_connection(GATEWAY_URL)
    end
    
  end