require 'parser.rb'

class Promotion < ApplicationRecord
  acts_as_tenant(:organization)

  scope :not_deleted, -> {where(deleted: false)}
  
  scope :by_code, -> (code) { where('code LIKE ?', "%#{code}%") }
  scope :by_name, -> (name) { where('name LIKE ?', "%#{name}%") }
  scope :by_type, -> (type) { where(type: type) }
  scope :active?, -> (status) { where(active: status) }
  enum return_type: %i[percentaje fixed_value]

  validates :code, uniqueness: true, presence: true
  validates :name, uniqueness: true, length: {minimum: 1}
  validates :return_type, inclusion: { in: return_types.keys}
  validates :return_value, numericality: { greater_than: 0 }
  validates :return_value, numericality: { less_than_or_equal_to: 100 }, if: :percentaje?
  before_validation :parse_condition

  # returns struct that indicates error if there is one, or result.
  def evaluate_applicability(arguments_values)
    if !active || deleted
      return {error: false, applicable: false, message: 'Promotion does not apply'}
    end
    begin
      return try_to_evaluate(arguments_values)
    rescue ParsingError, ActiveRecord::RecordInvalid => e
      return {error: true, message: e.message}
    end
  end

  protected

  def apply_promo(arguments)
    return true
  end

  private

  def try_to_evaluate(arguments_values)
    #parser = Parser.new(self.class.valid_arguments)
    parser = Parser.new()
    expr = parser.parse(condition)
    valid = expr.evaluate_condition(arguments_values)
    if valid
      apply_promo(arguments_values)
      return {error: false, applicable: true, return_type: return_type, return_value: return_value}
    else
      return {error: false, applicable: false}
    end
  end

  def calculate_saving(total)
    if return_type == :percentaje
      return (total * return_value)/100
    else
      return return_value
    end
  end

  def parse_condition
    #parser = Parser.new(self.class.valid_arguments.keys)
    parser = Parser.new()
    begin
      expr = parser.parse(condition)
      self.condition = expr.to_string
    rescue ParsingError => e
      errors.add(:condition, :invalid, message: e.message)
    end
  end

end
