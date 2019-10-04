class CreateJoinTablePromotionsApplicationKeys < ActiveRecord::Migration[6.0]
  def change
    create_join_table :promotions, :application_keys do |t|
      # t.index [:promotion_id, :application_key_id]
      # t.index [:application_key_id, :promotion_id]
    end
  end
end
