require 'parser.rb'

class Promotion < ApplicationRecord

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
    t_0 = Time.now.getutc
    if !active || deleted
      return {error: false, applicable: false, message: 'Promotion does not apply'}
    end
    begin
      return try_to_evaluate(arguments_values)
    rescue ParsingError, ActiveRecord::RecordInvalid => e
      add_negative_response()
      return {error: true, message: e.message}
    ensure
      update_average_response_time(t_0)
    end
  end

  def generate_report
    positive_responses = self.invocations - self.negative_responses
    negative_ratio = self.invocations > 0 ? Float(self.negative_responses) / self.invocations : 0
    positive_ratio = self.invocations > 0 ? Float(positive_responses) / self.invocations : 0
    report = {invocations_count: self.invocations, positive_ratio: positive_ratio, negative_ratio: negative_ratio,
       average_response_time: self.average_response_time, total_money_spent: self.total_spent}
    return report
  end

  protected

  def apply_promo(arguments)
    return true
  end

  private

  def try_to_evaluate(arguments_values)
    parser = Parser.new()
    expr = parser.parse(condition)
    valid = expr.evaluate_condition(arguments_values)
    add_invocation()
    if valid
      apply_promo(arguments_values)
      update_total_spent(arguments_values[:total])
      return {error: false, applicable: true, return_type: return_type, return_value: return_value}
    else
      add_negative_response()
      return {error: false, applicable: false}
    end
  end

  def update_total_spent(total)
    update(total_spent: self.total_spent + calculate_saving(total))
  end

  def add_invocation
    update(invocations: self.invocations + 1)
  end

  def add_negative_response
    update(negative_responses: self.negative_responses + 1)
  end

  def calculate_saving(total)
    if percentaje?
      return (total * return_value)/100
    else
      return return_value
    end
  end

  def update_average_response_time(beginning_time)
    current_average = self.average_response_time
    current_response_time = Time.now.getutc - beginning_time
    requests_count = self.invocations
    new_average = (requests_count * current_average + current_response_time)/(requests_count + 1)
    update(average_response_time: new_average)
  end

  def parse_condition
    parser = Parser.new()
    begin
      expr = parser.parse(condition)
      self.condition = expr.to_string
    rescue ParsingError => e
      errors.add(:condition, :invalid, message: e.message)
    end
  end

end
