# frozen_string_literal: true

class AddReportVariablesToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :invocations, :integer, null: false, default: 0
    add_column :promotions, :negative_responses, :integer, null: false, default: 0
    add_column :promotions, :average_response_time, :float, default: 0
    add_column :promotions, :total_spent, :float, default: 0
  end
end
