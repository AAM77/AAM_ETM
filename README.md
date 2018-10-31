
# AAM Event Task Manager (AAM ETA)

## Background

The inspiration for this app came during an attempt to plan a board game night with friends. In the end we did it over text message, but I wanted to see if I could build an app on Rails that could help us with THIS.

This project is currently built on Rails with as few gems as possible. I built it for Flatiron's Learn Verified Full stack Web Developer program.

## Description

A limited list of features for the app include:

(1) Users can create an account (the passwords is created with a salted encryption, so there is no way to retrieve it).
(2) Users can sign up or log in using their Facebook, Github, or Google accounts.
(3) If any of the social media account provides a username, that username is used. Otherwise one is generated.
(4) Users can change the display name (username) via the 'Profile' in the navbar, but not the email.
(5) Users can view only limited content on another user's page unless they are friends with the user.
(6) Users can view a list of all the events via the navbar.
(7) Users can view a list of all the tasks via the navbar.
(8) Each user can create events, which makes him/her the admin/organizer for that event.
(9) The admin of an event can create tasks from the admin page.
(10) Only users who are friends with the admin can join tasks for an event.
(11) Once a user completes one or more tasks, the user can mark those tasks complete for confirmation.
(12) The event admin/organizer must confirm task completion for it to be marked complete.
(13) Once an admin confirms a task complete, the task's participants are assigned a proportional amount of points.
(14) An event admin can delete tasks.
(15) An event admin can delete the event.
(16) Users can leave tasks, with confirmation.
(17) Users remain in a task even if they unfriend someone, but can still leave, if they choose to.
(18) A user can delete the account
(19) A user can log out

## Plans

The app is not complete yet. The front-end and back-end design will be refactored to be more efficient and pleasing to the eye.
I plan on improving the app's design and features after I graduate the program so that I can use Javascript to introduce behavior.

## Installation

You can simply download this repository to your machine and follow the instructions below to run it.

## Usage

At present, you can run this app by doing the following:

(Note: If you already have ruby and sinatra installed on your machine, skip to (5))
(1) Check if you have Ruby installed by typing 'ruby --version' into the terminal.
(2) Install using RVM. In the terminal, type:
' gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 '
' curl -sSL https://get.rvm.io | bash -s stable --ruby '
(3) Install bundler by typing, ' gem install bundler ' into the terminal
(4) Install Sinatra by typing, ' gem sinatra ' into the terminal

(5) Download or clone this repository
(6) Navigate to the 'aam_event_task_manager' directory on your machine using the terminal
(7) Next, type 'bundle install ' . This should install all of the gems it requires.
(8) Type ' rails s ' into the terminal
(9) Open your browser and navigate to 'http://localhost:3000' (press ctrl-C or control-C while in the terminal to exit.)
(10) Alternatively, if you wish to experiment with the app locally, you can do so by typing ' rails c ''

## Development

//THIS SECTION IS A PLACEHOLDER UNTIL I HAVE THE TIME TO REPLACE IT

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AAM77/aam_event_task_manager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the AAM Event Task Manager project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/AAM77/aam_event_task_manager/blob/master/CODE_OF_CONDUCT.md).

## License
The AAM Event Task Manager project has a Mozilla Public License. You may view the contents of the license at [license](https://github.com/AAM77/aam_event_task_manager/blob/master/LICENSE)

## Built With

* [Rails](https://guides.rubyonrails.org/) - The web framework used
* [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html) - For Handling Database communication and Model Associations.

## Contributing

//TO DO

## Versioning

//TO DO

## Authors

* **Mohammad Adeel**

## License

This project is licensed under the Mozilla Public License - see the [LICENSE.md](LICENSE.md) file for details
