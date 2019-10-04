# frozen_string_literal: true

require 'parser.rb'
require 'securerandom'
require_relative '../../lib/error/promotion_arguments_error.rb'
require_relative '../../lib/error/not_authorized_error.rb'

class Promotion < ApplicationRecord
  acts_as_tenant(:organization)

  belongs_to :organization

  scope :not_deleted, -> { where(deleted: false) }

  scope :by_code, ->(code) { where('code LIKE ?', "%#{code}%") }
  scope :by_name, ->(name) { where('name LIKE ?', "%#{name}%") }
  scope :by_type, ->(type) { where(type: type) }
  scope :active?, ->(status) { where(active: status) }
  enum return_type: %i[percentaje fixed_value]

  validates :code, uniqueness: true, presence: true
  validates :name, uniqueness: true, length: { minimum: 1 }
  validates :type, presence: true
  validates :return_type, presence: true, inclusion: { in: return_types.keys }
  validates :return_value, numericality: { greater_than: 0 }
  validates :return_value, numericality: { less_than_or_equal_to: 100 }, if: :percentaje?
  before_validation :parse_condition

  # returns struct that indicates error if there is one, or result.
  def evaluate_applicability(arguments_values, appkey)
    t_0 = Time.now.getutc
    begin
      return try_to_evaluate(arguments_values, appkey)
    rescue ParsingError, ActiveRecord::RecordInvalid => e
      add_negative_response
      raise PromotionArgumentsError, e.message
    ensure
      update_average_response_time(t_0)
    end
  end

  def generate_report
    positive_responses = invocations - negative_responses
    negative_ratio = invocations > 0 ? Float(negative_responses) / invocations : 0
    positive_ratio = invocations > 0 ? Float(positive_responses) / invocations : 0
    report = { invocations_count: invocations, positive_ratio: positive_ratio, negative_ratio: negative_ratio,
               average_response_time: average_response_time, total_money_spent: total_spent }
    report
  end

  protected

  # to be overriden.
  def apply_promo(arguments); end

  private

  def try_to_evaluate(arguments_values, appkey)
    add_invocation

    validate_authorization(appkey)
    validate_total_specified(arguments_values)

    if !active || deleted
      return { applicable: false, message: 'Promotion does not apply' }
    end

    if is_valid_condition(arguments_values)
      apply_promo(arguments_values)
      update_total_spent(arguments_values[:total])
      return { applicable: true, return_type: return_type, return_value: return_value }
    end

    add_negative_response
    { applicable: false }
  end

  def is_valid_condition(arguments_values)
    parser = Parser.new
    expr = parser.parse(condition)
    expr.evaluate_condition(arguments_values)
  end

  def validate_authorization(appkey)
    evaluation_allowed = is_from_clients_organization(appkey)
    unless evaluation_allowed
      add_negative_response
      raise NotAuthorizedError, "Can't access promotion from another organization"
    end
  end

  def validate_total_specified(arguments_values)
    unless arguments_values[:total].present?
      add_negative_response
      raise PromotionArgumentsError, 'Total must be specified'
    end
  end

  def is_from_clients_organization(appkey)
    organization_id == appkey.organization.id
  end

  def update_total_spent(total)
    update(total_spent: total_spent + calculate_saving(total))
  end

  def add_invocation
    update(invocations: invocations + 1)
  end

  def add_negative_response
    update(negative_responses: negative_responses + 1)
  end

  def calculate_saving(total)
    if percentaje?
      Float(total * return_value) / 100.0
    else
      return_value
    end
  end

  def update_average_response_time(beginning_time)
    current_average = average_response_time
    current_response_time = Time.now.getutc - beginning_time
    requests_count = invocations
    new_average = (requests_count * current_average + current_response_time) / (requests_count + 1)
    update(average_response_time: new_average)
  end

  def parse_condition
    parser = Parser.new
    begin
      expr = parser.parse(condition)
      self.condition = expr.to_string
    rescue ParsingError => e
      errors.add(:condition, :invalid, message: e.message)
    end
  end
end
