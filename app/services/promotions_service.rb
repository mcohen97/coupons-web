require_relative '../../lib/error/service_response_error.rb'

class PromotionsService
  include HttpRequests

#temporarily against microservice

GATEWAY_URL = 'https://coupons-evaluation.herokuapp.com'
PROMOTIONS_URL = 'https://coupons-evaluation.herokuapp.com/v1/promotions'


def self.instance()
  @instance = @instance || PromotionsService.new()
  return @instance
end

def get_promotions(filters, page =nil, offset = nil)
  route  = '/v1/promotions'
  if filters.any?
    route += add_filters(filters)
  end
  puts route
  promos = (get route).data
  promos.map{ |p| build_promo(p)}
end

def get_promotion_by_id(id)
  route  = '/v1/promotions/'+id
  result = get route
  if result.success
    build_promo(result.data)
  end
end

def get_coupon_instances(id)
  route = '/v1/promotions/'+id+'/coupons'
  get route
end

def create_promotion(payload)
  route  = '/v1/promotions'
  format_promotion_payload(payload)
  puts "payload #{payload.inspect}"
  result = post route, payload
  if result.success
    result.data = Promotion.new(result.data)
  end
  return result
end

def create_coupon_instances(promotion, payload)
  route = "/v1/promotions/#{promotion.id}/coupons"
  payload = create_coupon_instances_payload(promotion,payload)
  puts route
  puts payload.inspect
  post route, payload
end

def update_promotion(id, payload)
  route  = '/v1/promotions/' + id.to_s
  put route, payload
end

def delete_promotion(id)
  route  = '/v1/promotions/' + id.to_s
  delete route
end

private

  def initialize
    @connection = create_connection(GATEWAY_URL)
  end

  def create_coupon_instances_payload(promotion,payload)
    return {coupon_code: promotion.code, quantity: payload[:instances_count].to_i, max_uses: 10, expiration: convert_date(payload[:instance_expiration_date])}
  end

  def add_filters(filters)
    query_string = ''
    query_string += '?'
    filters.each do |filter, value|
        if query_string == '?'
          query_string += "#{filter}=#{value}"
        else
          query_string += "&#{filter}=#{value}"
        end
    end
    return query_string
  end

  def format_promotion_payload(payload)
    #payload[:promotion_type] = payload[:type].downcase
    #payload.delete(:type)
    payload[:expiration] = convert_date(payload[:expiration])
  end

  def build_promo(data)
    puts data
    data['new'] = false
    return Promotion.new(data)
  end

  def convert_date(date)
    date_tokens = date.split('/')
    day = date_tokens[1].to_i
    month = date_tokens[0].to_i
    year = date_tokens[2].to_i
    DateTime.new(year, month, day)
  end


end