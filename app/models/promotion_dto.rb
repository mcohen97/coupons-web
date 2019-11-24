class PromotionDto

  attr_accessor :name, :code, :type, :return_type, :return_value, :condition ,:active, :promotion_type, :expiration

  def initialize(args)
    @name = args['name']
    @code = args['code']
    @type = args['type']
    @return_type = args['return_type']
    @return_value = args['return_value']
    @condition = args['condition']
    @active = args['active']
    @promotion_type = args['promotion_type']
    @expiration_date = args['expiration']

  end

  def percentaje?
    @return_type == 'percentaje'
  end

end