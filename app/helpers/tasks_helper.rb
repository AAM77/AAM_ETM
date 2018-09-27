module TasksHelper

  # if the number of current participants is LESS THAN the max users allowed
  # then  if the current participants don't include the current user
  # then provide a link to join the event and redirect to the task's update action
  # but, if the current participants include the current user
  # then list out of the participants and provide a leave task with a redirect to the user_task destroy action
  # otherwise (if it does not contain the pa) just list out the participants

  def check_participant_join_status(task)
    if task.users.where("username = ?", current_user.username).first
      if task.users.size <= task.max_participants
        link_to "Leave Task", users_task_path(task), method: :delete
      end

    elsif task.users.size < task.max_participants
      if !task.users.where("username = ?", current_user.username).first
        link_to "Join Task", users_tasks_path(task, id: task.id), method: :post
      end

    else
      "Task Full"
    end
  end



end

#
#     elsif task.task_type == "Group Task"
#       if !task.users.where("username = ?", current_user.username).first
#         link_to "Join Event", task_path(task, visible: true), method: :patch
#       else
#        task.list_participants
#       end
#     else
#       task.list_participants
#     end
#   end
# end
# need to create a remove participant helper method
