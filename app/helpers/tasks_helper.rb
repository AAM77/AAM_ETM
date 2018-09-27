module TasksHelper

  def check_participants(task)
    if !task.users.where("username = ?", current_user.username).first
      link_to "Join Event", task_path(task, visible: true), method: :patch
    else
      task.list_participants
    end
  end

end
