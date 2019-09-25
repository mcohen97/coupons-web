require 'parser.rb'

class Discount < Promotion

  has_many :discount_usages
  enum valid_arguments: %i[transaction_id total quantity]
  #enum mandatory_arguments: %i[transaction_id]

  #def valid_promotion(arguments_values)
    #parser = Parser.new(Discount.valid_arguments.keys)
   # parser = Parser.new(arguments_values.keys + mandatory_arguments)
    #return parser.valid_promotion(@condition, arguments_values)
  #end

  def register_usage(arguments)
    discount = DiscountUsage.new(promotion_id: id, transaction_id: arguments[:transaction_id])
    discount.save!
  end

end
