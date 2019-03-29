# What I want to do with the admin/non-admin user concept and the events

# EVENTS ________ admins
#    |
#    |____________ non-admins
#


# EVENT attributes
#
# :name
# :tasks
# :users #=> admins
# :users #=> non_admins



# USER ___________ admin
#  |                 |______________ events
#  |
#  |_______________ non-admin
#                       |___________ events

# USER attributes
# :name



# user1 ______ admin_of = [event1, event2, event3]
#    |________ non-admin_of = [event4, event55:non-admin
#
#
# user2 ______ admin_of = [event1, event2, event4]
#    |________ non-admin_of = [event3, event5]
#
#
# user3 ______ admin_of = [event1, event5]
#    |________ non-admin_of = [event2, event3, event4]
#
#
# event1 ______ admins = [user1, user2, user3]
#    |_________ non-admins = []
#
#
# event2 ______ admins = [user1, user2]
#    |_________ non-admins = [user3]
#
#
# event3 ______ admins = [user1]
#    |_________ non-admins = [user2, user3]
#
#
# event4 ______ admin = [user2]
#    |_________ non-admins = [user1, user3]
#
#
# event5 ______ admin = [user3]
#    |_________ non-admins = [user1, user2]
#
#

# user_event_table
# id: 1,  user_id:1,  event_id: 1, admin: true
# id: 2,  user_id:2,  event_id: 1, admin: true
# id: 3,  user_id:3,  event_id: 1, admin: true
# id: 4,  user_id:1, event_id: 2, admin: true
# id: 5,  user_id:2, event_id: 2, admin: true
# id: 6,  user_id:3, event_id: 2, admin: false
# id: 7,  user_id:1, event_id: 3, admin: true
# id: 8,  user_id:2, event_id: 3, admin: false
# id: 9,  user_id:3, event_id: 3, admin: false
# id: 10, user_id:1, event_id: 4, admin: false
# id: 11, user_id:2, event_id: 4, admin: true
# id: 12, user_id:3, event_id: 4, admin: false
# id: 13, user_id:1, event_id: 5, admin: false
# id: 14, user_id:2, event_id: 5, admin: false
# id: 15, user_id:3, event_id: 5, admin: true
