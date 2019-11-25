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

def get_promotions(filters, authorization, page =nil, offset = nil)
  route  = '/v1/promotions'
  if filters.any?
    route += add_filters(filters)
  end
  puts route
  promos = (get route, authorization).data
  promos.map{ |p| build_promo(p)}
end

def get_promotion_by_id(id, authorization)
  route  = '/v1/promotions/'+id
  result = get route, authorization
  if result.success
    build_promo(result.data)
  end
end

def get_coupon_instances(id, authorization)
  route = '/v1/promotions/'+id+'/coupons'
  get route, authorization
end

def create_promotion(payload, authorization)
  route  = '/v1/promotions'
  format_payload(payload)
  puts "payload #{payload.inspect}"
  result = post route, payload, authorization
  if result.success
    result.data = PromotionDto.new(result.data)
  end
  return result
end

def update_promotion(id, payload, authorization)
  route  = '/v1/promotions/' + id
  put route, payload, authorization
end

def delete_promotion(id, authorization)
  route  = '/v1/promotions/' + id.to_s
  delete route, authorization
end

private

  def initialize
    @connection = create_connection(GATEWAY_URL)
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

  def format_payload(payload)
    payload[:promotion_type] = payload[:type].downcase
    date_tokens = payload[:expiration].split('/')
    day = date_tokens[1].to_i
    month = date_tokens[0].to_i
    year = date_tokens[2].to_i
    payload[:expiration] = DateTime.new(year, month, day)
  end

  def build_promo(data)
    promo_type = data['promotion_type']
    data.delete('promotion_type')
    return promo_type == 'discount' ? Discount.new(data) : Coupon.new(data)
  end

end