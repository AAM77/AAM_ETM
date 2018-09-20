# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc 'Reboots the Database'
task :'db:reboot' do
  Rake::Task["db:drop"].execute

  ActiveRecord::Tasks::DatabaseTasks.env = 'test'
  Rake::Task["db:create"].execute
  Rake::Task["db:migrate"].execute

  ActiveRecord::Tasks::DatabaseTasks.env = 'development'
  Rake::Task["db:create"].execute
  Rake::Task["db:migrate"].execute

  Rake::Task["db:seed"].execute
end
