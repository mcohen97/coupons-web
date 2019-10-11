# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Faker::Config.random = Random.new(42)

pedidos_ya = Organization.create!(organization_name: 'Pedidos Ya')
rappi = Organization.create!(organization_name: 'Rappi')

pablo = User.create!(name: 'Pablo', surname: 'Villas', email: 'pv@gmail.com', password: '123456', role: 'administrator', organization_id: pedidos_ya.id)
simon = User.create!(name: 'Simon', surname: 'Borreo', email: 'sb@gmail.com', password: '123456', role: 'administrator', organization_id: rappi.id)

dis1 = Discount.create!(code: 'discount1', name: 'a discount', return_type: :percentaje,
                        return_value: 10, active: true, condition: '( total <= 100 AND quantity >= 5 ) OR total > 10', organization_id: pablo.organization_id)

dis2 = Discount.create!(code: 'discount2', name: 'another discount', return_type: :percentaje,
                        return_value: 10, active: false, condition: '( total <= 100 AND quantity >= 5 ) OR total > 10', organization_id: pablo.organization_id)

dis3 = Discount.create!(code: 'discount3', name: 'and yet another discount', return_type: :fixed_value,
                        return_value: 10, active: false, condition: 'quantity >= 5', organization_id: pablo.organization_id)

coup1 = Coupon.create!(code: 'coupon1', name: 'a coupon', return_type: :percentaje,
                       return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2', organization_id: simon.organization_id)

coup2 = Coupon.create!(code: 'coupon2', name: 'another coupon', return_type: :percentaje,
                       return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2', organization_id: simon.organization_id, deleted: true)

rand_promotions = []

coup = Coupon.create!(code: 'couponcodetest', name: 'Some coupy coupon', return_type: :percentaje,
                      return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2', organization_id: pablo.organization_id)

(0..512).each do |i|
  dis = Discount.create!(code: Faker::Commerce.unique.promotion_code, name: Faker::Commerce.unique.product_name, return_type: :percentaje,
                         return_value: 10, active: true, condition: '( total <= 100 AND quantity >= 5 ) OR total > 10', organization_id: pablo.organization_id)
  CouponInstance.create!(promotion_id: coup.id, coupon_code: "coupon#{coup.id}-#{i}")

  rand_promotions << dis
end
rand_promotions << coup

CouponInstance.create!(promotion_id: 4, coupon_code: 'coupon1-1')
CouponInstance.create!(promotion_id: 4, coupon_code: 'coupon1-2')

ApplicationKey.create!(name: 'All pedidos ya', organization_id: pedidos_ya.id, promotion_ids: rand_promotions.pluck(:id))
ApplicationKey.create!(name: 'pedidosYaKey', organization_id: pedidos_ya.id, promotion_ids: [dis1.id, dis2.id, dis3.id])
ApplicationKey.create!(name: 'pedidosYaKeyIncompleto', organization_id: pedidos_ya.id, promotion_ids: [dis1.id])
ApplicationKey.create!(name: 'rappiKey', organization_id: rappi.id, promotion_ids: [coup1.id, coup2.id])
