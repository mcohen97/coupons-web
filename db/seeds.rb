# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

pedidos_ya = Organization.create!(organization_name: 'Pedidos Ya')
rappi = Organization.create!(organization_name: 'Rappi')

pablo = User.create!(name: 'Pablo', surname: 'Villas', email: 'pv@gmail.com', password: '123456', role: 'administrator', organization_id: pedidos_ya.id)
simon = User.create!(name: 'Simon', surname: 'Borreo', email: 'sb@gmail.com', password: '123456', role: 'administrator', organization_id: rappi.id)

Discount.create!(code: 'discount1', name: 'a discount', return_type: :percentaje,
                 return_value: 10, active: true, condition: '( total <= 100 AND quantity >= 5 ) OR total > 10', organization_id: pablo.organization_id)

Discount.create!(code: 'discount2', name: 'another discount', return_type: :percentaje,
                 return_value: 10, active: false, condition: '( total <= 100 AND quantity >= 5 ) OR total > 10', organization_id: pablo.organization_id)

Coupon.create!(code: 'coupon1', name: 'a coupon', return_type: :percentaje,
               return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2', organization_id: simon.organization_id)

Coupon.create!(code: 'coupon2', name: 'another coupon', return_type: :percentaje,
               return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2', organization_id: simon.organization_id, deleted: true)

CouponInstance.create!(promotion_id: 3, coupon_code: 'coupon1-1')
CouponInstance.create!(promotion_id: 3, coupon_code: 'coupon1-2')

ApplicationKey.create!(name: 'pedidosYaKey', organization_id: pedidos_ya.id)
ApplicationKey.create!(name: 'rappiKey', organization_id: rappi.id)
