# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

promo = Discount.new(code: 'code4',
  name: 'promotion 4',
  return_type: :fixed_value,
  return_value: 15,
  active: false)


promo.save!

=begin


promo =Discount.new(code: 'code1',
                 name: 'promotion 1',
                 return_type: 'percentaje',
                 return_value: 10,
                 active: true)
promo.save!

Promotion.create(code: 'code2',
              name: 'promotion 2',
              return_value: 15,
              active: false)

              return_type: Promotion.fixed_value,
                 return_type: Promotion.percentaje


Discount.create(code: 'code1',
                 name: 'promotion 1',
                 return_value: 10,
                 active: true,
                 return_type: Promotion.percentaje)

Promotion.create(code: 'code2',
              name: 'promotion 2',
              return_value: 15,
              return_type: Promotion.fixed_value,
              active: false)



promo1.percentaje!

promo2 = Promotion.new(code: 'code2',
                       name: 'promotion 2',
                       return_value: 15,
                       active: false)
promo2.percentaje!

promo3 = Promotion.new(code: 'code3',
                       name: 'promotion 3',
                       return_value: 150,
                       active: true)
promo3.fixed_value!

promo1.save!
promo2.save!
promo3.save!
=end
