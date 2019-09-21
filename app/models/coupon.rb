require 'parser.rb'

class Coupon < Promotion
  enum valid_arguments: %i[coupon_code total products_size]
  before_validation :parse_condition

  def valid_promotion(arguments_values)
    parser = Parser.new(Discount.valid_arguments)
    return parser.valid_promotion(@condition, arguments_values)
  end  
end
=begin
private

  def parse_condition
    parser = Parser.new(Discount.valid_arguments.keys)
    begin
      self.condition = parser.format_expression(self.condition)
    rescue ParsingError => e
      errors.add(:condition, :invalid, message: e.message)
    end
  end

end
=end