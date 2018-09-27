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
    ["first_name", "last_name", "username", "email", "address", "telephone_num", "password"],
  :users => [
    ["Max", "Charles", "max_c", "max_c@info.com", "281 Old Willow St. New Castle, PA 16101", "(593) 412-0356", "password"],
    ["Skai", "Jackson", "skai_j", "skai_j@info.com", "536 N. Union St. Reisterstown, MD 21136", "(657) 750-9467", "password"],
    ["Kaleo", "Elam", "kaleo_e", "kaleo_e@info.com", "80 Old Peg Shop Drive Fair Lawn, NJ 07410", "(834) 492-7512", "password"],
    ["Megan", "Charpentier", "megan_c", "megan_c@info.com", "9360 Greystone St. Palm Coast, FL 32137", "(940) 578-5526", "password"],
    ["Hayden", "Byerly", "hayden_b", "hayden_b@info.com", "8793 Beach St. Rockville, MD 20850", "(558) 579-2138", "password"],
    ["Tenzing", "Norgay Trainor", "tenzing_n", "tenzing_n@info.com", "26 High Noon Lane Charlottesville, VA 22901", "(743) 737-4430", "password"],
    ["Davis", "Cleveland", "davis_c", "davis_c@info.com", "753 St Margarets St. Port Orange, FL 32127", "(481) 557-7701", "password"],
    ["Cole", "Sand", "cole_s", "cole_s@info.com", "187 E. Thomas St. Elizabeth City, NC 27909", "(516) 654-9062", "password"],
    ["Quvenzhane", "Wallis", "quven_w", "quven_w@info.com", "9760 Meadowbrook Lane Freeport, NY 11520", "(416) 983-6369", "password"]
  ],

  :event_keys =>
   ["name", "admin_id"],
  :events => [
    ["Scrambler Ride", 1],
    ["Miniature Railroad", 1],
    ["Merry-Go-Round", 2],
    ["Roller Coaster", 2],
    ["Swinging Ship", 2],
    ["Go Karts", 3],
    ["Haunted Mansion", 3],
    ["Ferris Wheel", 4],
    ["Teacups Ride", 5]
  ],

  :task_keys =>
   ["name", "group_task", "points_awarded", "max_participants"],
  :tasks => [
    ["Iron Clothes", false, 2, 1],
    ["Wash Dishes", false, 4, 1],
    ["Mow the Lawn", false, 5, 1],
    ["Clean the Bathroom", true, 10, 3],
    ["Clean the Kitchen", true, 10, 3],
    ["Organize the Garage", true, 15, 5],
    ["Clean the Garage", true, 10, 4],
    ["Wash the Car", false, 7, 1]
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

def make_events
  DATA[:events].each do |event|
    new_event = Event.new
    event.each_with_index do |attribute, i|
      new_event.send(DATA[:event_keys][i]+"=", attribute)
    end

    rand(1..8).times do
      users = []
      User.all.each {|u| users << u } #if u.admin != true}
      new_event.users << users[rand(0...users.length)]
    end

    new_event.users.each { |c| c.save }
    new_event.save
    make_tasks(new_event)
  end
end

def make_tasks(current_event)
  DATA[:tasks].each do |task|
    new_task = Task.new
    task.each_with_index do |attribute, i|
      new_task.send(DATA[:task_keys][i]+"=", attribute)
    end
    new_task.event_id = current_event.id

    if new_task.group_task

      rand(1..8).times do
        users = []
        User.all.each {|u| users << u if !users.find { |s| s.username == u.username } }
        new_task.users << users[rand(0...users.length)]
      end

    else

      1.times do
        users = []
        User.all.each {|u| users << u } #if u.admin != true}
        new_task.users << users[rand(0...users.length)]
      end
    end

    new_task.users.each {|c| c.save}
    new_task.save
  end
end

make_users
make_events
