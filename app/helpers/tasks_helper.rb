module TasksHelper

  # if the number of current participants is LESS THAN the max users allowed
  # then  if the current participants don't include the current user
  # then provide a link to join the event and redirect to the task's update action
  # but, if the current participants include the current user
  # then list out of the participants and provide a leave task with a redirect to the user_task destroy action
  # otherwise (if it does not contain the pa) just list out the participants

  #################################
  # Lists the task's participants #
  #################################
  def task_participants(task)
    task.users.map { |participant| (link_to participant.username, user_path(participant)) }
  end

end
