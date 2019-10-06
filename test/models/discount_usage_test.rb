# frozen_string_literal: true

require 'test_helper'

class DiscountUsageTest < ActiveSupport::TestCase
  test "should save usage with specified data" do
    usage = DiscountUsage.new(promotion_id: 2, transaction_id: 123)
    assert usage.save
    assert_equal(2, usage.promotion_id)
    assert_equal('123', usage.transaction_id)
  end

  test "should not save usage with empty transaction id" do
    usage = DiscountUsage.new(promotion_id: 2)
    assert_not usage.save
    assert usage.errors[:transaction_id].any?
  end

  test "should not allow repeated transaction ids" do
    usage = DiscountUsage.new(promotion_id: 2, transaction_id: 123)
    assert usage.save
    usage = DiscountUsage.new(promotion_id: 2, transaction_id: 123)
    assert_not usage.save
    assert usage.errors[:transaction_id].any?
  end
end