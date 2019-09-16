class Promotion < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, uniqueness: true

  enum return_type: %i[percentaje fixed_value]

  def valid_promotion(arguments)
    # abstract method to be overriden
  end
end
