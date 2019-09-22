require 'parser.rb'

class Coupon < Promotion
  enum valid_arguments: %i[coupon_code total products_size]

  def valid_promotion(arguments_values)
    parser = Parser.new(Discount.valid_arguments)
    return parser.valid_promotion(@condition, arguments_values)
  end
end