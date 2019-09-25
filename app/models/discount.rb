require 'parser.rb'

class Discount < Promotion

  has_many :discount_usages
  enum valid_arguments: %i[transaction_id total quantity]
  #enum mandatory_arguments: %i[transaction_id]

  def register_usage(arguments)
    discount = DiscountUsage.new(promotion_id: id, transaction_id: arguments[:transaction_id])
    discount.save!
  end

end
