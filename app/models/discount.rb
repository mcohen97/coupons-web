# frozen_string_literal: true

require 'parser.rb'

class Discount < Promotion
  has_many :discount_usages

  def apply_promo(arguments)
    discount = DiscountUsage.new(promotion_id: id, transaction_id: arguments[:transaction_id])
    discount.save!
  end
end
