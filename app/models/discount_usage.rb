# frozen_string_literal: true

class DiscountUsage < ApplicationRecord
  belongs_to :promotion
  validates :transaction_id, presence: true
  validates_uniqueness_of :transaction_id
end
