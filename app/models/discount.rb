require 'parser.rb'

class Discount < Promotion
  enum valid_arguments: %i[transaction_id total quantity]

  def valid_promotion(arguments_values)
    parser = Parser.new(Discount.valid_arguments.keys)
    return parser.valid_promotion(@condition, arguments_values)
  end
end
