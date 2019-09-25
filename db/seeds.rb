# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Discount.create(code: 'discount1', name: 'a discount', return_type: :percentaje,
  return_value: 10, active: true, condition: '( total <= 100 AND quantity >= 5 ) OR total > 10')

Coupon.create(code: 'coupon1', name: 'a coupon', return_type: :percentaje,
  return_value: 10, active: true, condition: 'total > 100 AND products_size >= 2')
