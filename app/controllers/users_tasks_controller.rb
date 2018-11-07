class UsersTasksController < ApplicationController
  before_action :redirect_if_not_logged_in
  # temporary/stop-gap measure to prevent remove authenticity_token errors
  skip_before_action :verify_authenticity_token, only: [:user_complete, :admin_complete]

  ###################################################################
  # handles creating a record of the user's participation (joining) in a task #
  ###################################################################
  def create
    task = Task.find(params[:id])

    if task.detect_user?(current_user)
      flash[:warnings] = [ "You cannot join this task twice." ]
    else
      task.add_participant(current_user)
      flash[:success] = "You have successfully joined task: #{task.name}"
    end

    redirect_to event_path(task.event_id)
  end


  #############################################
  # handles marking a task complete by a user #
  #############################################
  def user_complete
    if params[:user_task_ids]
      params[:user_task_ids].each do |user_task_id|
        task = Task.find(user_task_id)
        task.update(user_completed_at: Time.now)
      end

      flash[:success] = "Tasks successfully marked complete."
    else
      flash[:warnings] = [ "You did not select any tasks to complete." ]
    end

    redirect_to event_path(params[:task][:event_id])
  end

  ###############################################
  # handles marking a task complete by an admin #
  ###############################################
  def admin_complete
    if params[:admin_task_ids]
      params[:admin_task_ids].each do |admin_task_id|
        task = Task.find(admin_task_id)
        task.update(admin_confirmed_completion_at: Time.now)
        task.distribute_points
      end

      flash[:success] = "Tasks successfully confirmed complete."
    else
      flash[:warnings] = [ "You did not select any tasks to complete." ]
    end

    redirect_to show_admin_event_path(params[:task][:event_id])
  end

  ###################################################################
  # handles deleting a record of the user's participation in a task #
  ###################################################################
  def destroy
    task = Task.find(params[:id])

    if task.detect_user?(current_user)
      task.remove_participant(current_user)
      flash[:success] = "You have left the task: #{task.name}."
    else
      flash[:warnings] = [ "You cannot leave a task you are nt participating in!" ]
    end

    redirect_to event_path(task.event_id)
  end

end
