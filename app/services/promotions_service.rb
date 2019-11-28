require_relative '../../lib/error/service_response_error.rb'

class PromotionsService
  include HttpRequests

#temporarily against microservice

  GATEWAY_URL = 'https://coupons-gateway.herokuapp.com'


  def self.instance()
    @instance = @instance || PromotionsService.new()
    return @instance
  end

  def get_promotions(filters = [], limit = 1000, offset = 0)
    route = "/v1/promotions?limit=#{limit}&offset=#{offset}"
    if filters.any?
      route += add_filters(filters)
    end
    promos = (get route).data
    promos.map { |p| build_promo(p) }
  end

  def get_promotion_by_id(id)
    route = '/v1/promotions/' + id
    result = get route
    if result.success
      build_promo(result.data)
    end
  end

  def get_coupon_instances(id)
    route = '/v1/promotions/' + id + '/coupons'
    get route
  end

  def create_promotion(payload)
    route = '/v1/promotions'
    format_promotion_payload(payload)
    puts "payload #{payload.inspect}"
    result = post route, payload

    if result.success
      result.data['expiration'] = to_simple_date result.data['expiration']
      result.data = Promotion.new(result.data)
    end
    return result
  end

#Date format from backend
  def to_simple_date(date)
    return nil unless date
    t = DateTime.parse(date)
    t.strftime("%m/%d/%Y")
  end

  def create_coupon_instances(coupon_instances)
    puts "CREATE COUPON INSTANCES"
    route = "/v1/promotions/#{coupon_instances.promotion_id}/coupons"
    payload = {
        coupon_code: coupon_instances.coupon_code,
        quantity: coupon_instances.quantity.to_i,
        expiration: convert_date(coupon_instances.expiration),
        max_uses: coupon_instances.max_uses.to_i
    }
    puts payload.inspect
    post route, payload
  end

  def update_promotion(id, payload)
    route = '/v1/promotions/' + id.to_s
    put route, payload
  end

  def delete_promotion(id)
    route = '/v1/promotions/' + id.to_s
    delete route
  end

  def self.build_coupon_instance(data)
    exp = DateTime.parse(data['expiration'])
    data['expiration'] = exp.strftime('%m/%d/%Y')
    CouponInstancesDto.new(data)
  end


  private

  def initialize
    @connection = create_connection(GATEWAY_URL)
  end

  def create_coupon_instances_payload(coupon_instances, payload)
    return {coupon_code: coupon_instances.code, quantity: payload[:instances_count].to_i, max_uses: 10, expiration: convert_date(payload[:instance_expiration_date])}
  end

  def add_filters(filters)
    query_string = ''
    filters.each do |filter, value|
      query_string += "&#{filter}=#{value}"
    end
    query_string
  end

  def format_promotion_payload(payload)
    payload[:expiration] = convert_date(payload[:expiration])
  end

  def build_promo(data)
    data['new'] = false
    exp = DateTime.parse(data['expiration'])
    data['expiration'] = exp.strftime('%m/%d/%Y')
    Promotion.new(data)
  end


  def convert_date(date)
    date_tokens = date.split('/')
    day = date_tokens[1].to_i
    month = date_tokens[0].to_i
    year = date_tokens[2].to_i
    DateTime.new(year, month, day)
  end


end