module EventsHelper

  ### FINISHED EDITING ###

  ###########################################################
  # Determines if the current_user is an admin of the event #
  ###########################################################
  def user_is_event_admin(event)
    event.admin_id == current_user.id
  end

  ####################################################################################
  # Displays a checkbox or appropriate message depending on a task's complete status #
  ####################################################################################
  def display_user_checkbox(task)
    if task.admin_confirmed_completion_at
      "Complete"
      task.completed = true
      task.save
    elsif task.user_completed_at && !task.admin_confirmed_completion_at
      "Pending Confirmation"
    elsif task.user_ids.include?(current_user.id)
      check_box_tag "user_task_ids[]", task.id
    end
  end

  #####################################
  # Displays checkboxes for the admin #
  #####################################
  def display_admin_checkbox(task)
    check_box_tag "admin_task_ids[]", task.id
  end

  ###################################################
  # Checks if the visiting user is the task's admin #
  ###################################################
  def is_admin_user?(task)
    task.admin_id == current_user.id
  end

  ####################################################
  # Determines if the visting user can join the task #
  ####################################################
  def permission_to_join?(task)
    if friends?(task.admin_id) || is_admin_user?(task)
      yield
    else
      "Cannot Join"
    end
  end


  #########################################################
  # Determines if a user if participating in an event     #
  # Displays 'Join Task' or 'Leave Task' link accordingly #
  #########################################################
  def check_task_availability(task)
    unless  task.completed
      if task.user_ids.include?(current_user.id)
        if task.users.size <= task.max_participants
          link_to "Leave Task", users_task_path(task), method: :delete, data: { confirm: "Are you sure you wish to leave task: #{task.name}?"}
        end

      elsif task.users.size < task.max_participants
        unless task.user_completed_at
          if task.user_ids.exclude?(current_user.id)
            link_to "Join Task", users_tasks_path(task, id: task.id), method: :post
          end
        end

      else
        "Task Full"
      end
    end
  end

end
