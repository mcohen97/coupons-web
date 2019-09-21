require 'parser.rb'

class Promotion < ApplicationRecord

  enum return_type: %i[percentaje fixed_value]
  # valid arguments will be overriden by each type of promotion.
  enum valid_arguments: %i[]


  validates :code, uniqueness: true, presence: true
  validates :name, uniqueness: true, length: {minimum: 1}
  validates :return_type, inclusion: { in: return_types.keys}
  validates :return_value, numericality: { greater_than: 0 }
  validates :return_value, numericality: { less_than_or_equal_to: 100 }, if: :percentaje?
  before_validation :parse_condition

  def valid_promotion(arguments)
    # abstract method to be overriden
  end

  def parse_condition
    parser = Parser.new(Discount.valid_arguments.keys)
    begin
      self.condition = parser.format_expression(self.condition)
    rescue ParsingError => e
      errors.add(:condition, :invalid, message: e.message)
    end
  end

end
