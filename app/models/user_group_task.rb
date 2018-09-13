class UserGroupTask < ApplicationRecord
  belongs_to :user
  belongs_to :group_task, class_name: "Task"
end
