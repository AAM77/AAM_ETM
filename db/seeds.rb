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

# t.string :name
# t.date :date_created
# t.date :event_date
# t.date :deadline_date
# t.time :deadline_time
# admin

DATA = {
  :user_keys =>
    ["name", "username", "email", "address", "telephone_num", "password"],
  :users => [
    ["Max Charles", "max_c", "max_c@info.com", "281 Old Willow St. New Castle, PA 16101", "(593) 412-0356", "password"],
    ["Skai Jackson", "skai_j", "skai_j@info.com", "536 N. Union St. Reisterstown, MD 21136", "(657) 750-9467", "password"],
    ["Kaleo Elam", "kaleo_e", "kaleo_e@info.com", "80 Old Peg Shop Drive Fair Lawn, NJ 07410", "(834) 492-7512", "password"],
    ["Megan Charpentier", "megan_c", "megan_c@info.com", "9360 Greystone St. Palm Coast, FL 32137", "(940) 578-5526", "password"],
    ["Hayden Byerly", "hayden_b", "hayden_b@info.com", "8793 Beach St. Rockville, MD 20850", "(558) 579-2138", "password"],
    ["Tenzing Norgay Trainor", "tenzing_n", "tenzing_n@info.com", "26 High Noon Lane Charlottesville, VA 22901", "(743) 737-4430", "password"],
    ["Davis Cleveland", "davis_c", "davis_c@info.com", "753 St Margarets St. Port Orange, FL 32127", "(481) 557-7701", "password"],
    ["Cole Sand", "cole_s", "cole_s@info.com", "187 E. Thomas St. Elizabeth City, NC 27909", "(516) 654-9062", "password"],
    ["Quvenzhané Wallis", "quven_w", "quven_w@info.com", "9760 Meadowbrook Lane Freeport, NY 11520", "(416) 983-6369", "password"]
  ],
  :event_keys =>
   ["name"],
  :events => [
    ["Scrambler Ride"],
    ["Miniature Railroad"],
    ["Merry-Go-Round"],
    ["Roller Coaster"],
    ["Swinging Ship"],
    ["Go Karts"],
    ["Haunted Mansion"],
    ["Ferris Wheel"],
    ["Teacups Ride"]
  ],
  :admins => [
    "Mary Elitch Long",
    "John Elitch"
  ]
}

def make_users
  DATA[:users].each do |user|
    new_user = User.new
    user.each_with_index do |attribute, i|
      new_user.send(DATA[:user_keys][i]+"=", attribute)
    end
    new_user.save
  end
end


make_users
