
class Services

  def self.promotions_service
    @@services ||= proxy_services
    @@services[:promotions_service]
  end

  def self.proxy_services
    service  = PromotionsService.new()

    { promotions_service: service }
  end
end