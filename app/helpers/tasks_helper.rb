module TasksHelper

  def check_participants(task)
    if task.list_participants.empty?
      link_to "Join Event"
    else
      task.list_participants
    end
  end

end
