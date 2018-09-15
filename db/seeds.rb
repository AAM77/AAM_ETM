# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


DATA = {
  :user_keys =>
    ["name", "username", "email", "address", "telephone_num", "password"],
  :users => [
    ["Max Charles", "max_charles", "max_charles@info.com", "281 Old Willow St. New Castle, PA 16101", "(593) 412-0356", "password"],
    ["Skai Jackson", "skai_jackson", "skai_jackson@info.com", "536 N. Union St. Reisterstown, MD 21136", "(657) 750-9467", "password"],
    ["Kaleo Elam", "kaleo_elam", "kaleo_elam@info.com", "80 Old Peg Shop Drive Fair Lawn, NJ 07410", "(834) 492-7512", "password"],
    ["Megan Charpentier", "megan_c", "megan_c@info.com", "9360 Greystone St. Palm Coast, FL 32137", "(940) 578-5526", "password"],
    ["Hayden Byerly", "hayden_b", "hayden_b@info.com", "8793 Beach St. Rockville, MD 20850", "(558) 579-2138", "password"],
    ["Tenzing Norgay Trainor", "tenzing_n", "tenzing_n@info.com", "26 High Noon Lane Charlottesville, VA 22901", "(743) 737-4430", "password"],
    ["Davis Cleveland", "davis_c", "davis_c@info.com", "753 St Margarets St. Port Orange, FL 32127", "(481) 557-7701", "password"],
    ["Cole Sand", "cole_s", "cole_s@info.com", "187 E. Thomas St. Elizabeth City, NC 27909", "(516) 654-9062", "password"],
    ["Quvenzhané Wallis", "quven_w", "quven_w@info.com", "9760 Meadowbrook Lane Freeport, NY 11520", "(416) 983-6369", "password"]
  ],
  :attraction_keys =>
   ["name", "nausea_rating", "happiness_rating", "tickets", "min_height"],
  :attractions => [
    ["Scrambler Ride", 2, 2, 2, 36],
    ["Miniature Railroad", 0, 1, 2, 32],
    ["Merry-Go-Round", 1, 1, 1, 30],
    ["Roller Coaster", 1, 3, 4, 54],
    ["Swinging Ship", 2, 2, 2, 36],
    ["Go Karts", 1, 2, 3, 36],
    ["Haunted Mansion", 1, 1, 1, 30],
    ["Ferris Wheel", 1, 1, 2, 36],
    ["Teacups Ride", 3, 1, 1, 28]
  ],
  :admins => [
    "Mary Elitch Long",
    "John Elitch"
  ]
}

def main
  make_users
  make_admin
  make_attractions_and_rides
end

def make_users
  DATA[:users].each do |user|
    new_user = User.new
    user.each_with_index do |attribute, i|
      new_user.send(DATA[:user_keys][i]+"=", attribute)
    end
    new_user.save
  end
end

def make_admin
  DATA[:admins].each do |name|
    User.create(name: name, admin: true, password: 'password')
  end
end

def make_attractions_and_rides
  DATA[:attractions].each do |attraction|
    new_attraction = Attraction.new
    attraction.each_with_index do |attribute, i|
      new_attraction.send(DATA[:attraction_keys][i] + "=", attribute)
    end
    rand(1..8).times do
      customers = []
      User.all.each {|u| customers << u if u.admin != true}
      new_attraction.users << customers[rand(0...customers.length)]
    end
    new_attraction.users.each {|c| c.save}
    new_attraction.save
  end
end

main
