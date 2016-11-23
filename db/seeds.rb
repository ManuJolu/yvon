
print "Destroying everything"

OrderedMeal.destroy_all
Meal.destroy_all
Order.destroy_all
Restaurant.destroy_all
User.destroy_all
puts "   💥"

Faker::Config.locale = 'fr'

print "Creating Users"
10.times do
  user = User.new({
    email: Faker::Internet.email,
    password: "123456",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
    })
  user.encrypted_password="ENCRYPT.MY.ASS!!!KJASOPJ090923ULXCIULSH.IXJ!S920"
  user.save
  print "🐎  "

end

print "Creating restaurants"
10.times do
  restaurant = Restaurant.new ({
    name: Faker::Pokemon.name,
    address: "#{Faker::Address.city}, France",
    category: rand(0..6),
    description: Faker::Hipster.sentence,
    photo_url: "http://res.cloudinary.com/dsc0gdltc/image/upload/v1479894819/e0umkfjymjlzhaytwfaw.jpg"
  })
  restaurant.user = User.all[rand(0..4)]
  restaurant.save
  print "🐎  "
end

print "Creating meals"
30.times do
  meal = Meal.new ({
    name: Faker::GameOfThrones.city,
    price: rand(3..90),
    category: rand(0..3),
    photo_url: "http://res.cloudinary.com/dsc0gdltc/image/upload/v1479894819/e0umkfjymjlzhaytwfaw.jpg"
})
  meal.restaurant = Restaurant.all[rand(0..9)]
  meal.save
  print "🐎  "
end

print "Creating orders"
10.times do
  order = Order.new ({
    })
  order.restaurant = Restaurant.all[rand(0..9)]
  order.user = User.all[rand(5..9)]
  order.save
  print "🐎  "
end


print "Creating ordered meals"
50.times do
  ordered_meal = OrderedMeal.new ({
    })
  ordered_meal.order = Order.all[rand(0..9)]
  ordered_meal.meal = Meal.all[rand(0..29)]
  ordered_meal.save
  print "🐎  "
end
