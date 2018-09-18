class TaskType < ActiveRecord::Base

  def self.create_task_types
    TaskType.new(name: "Solo Task").save if !TaskType.find_by(name: "Solo Task")
    TaskType.new(name: "Group Task").save if !TaskType.find_by(name: "Group Task")
  end

end
