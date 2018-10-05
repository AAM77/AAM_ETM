class UsersTasksController < ApplicationController

  ###################################################################
  # handles creating a record of the user's participation in a task #
  ###################################################################
  def create
    @task = Task.find(params[:id])
    @task.add_participant(current_user)
    redirect_to event_path(@task.event_id)
  end


  ###################################################################
  # handles deleting a record of the user's participation in a task #
  ###################################################################
  def destroy
    @task = Task.find(params[:id])
    @task.remove_participant(current_user)
    redirect_to event_path(@task.event_id)
  end

  #############################################
  # handles marking a task complete by a user #
  #############################################
  def user_complete
    @task = Task.find(params[:user_task_ids].first)
    @event = Event.find(@task.event_id)
    @task = Task.where(id: params[:user_task_ids]).update_all(["user_completed_at=?", Time.now])
    redirect_to event_path(@event)
  end

  ###############################################
  # handles marking a task complete by an admin #
  ###############################################
  def admin_complete
    @task = Task.find(params[:admin_task_ids].first)
    @event = Event.find(@task.event_id)
    Task.where(id: params[:admin_task_ids]).update_all(["admin_confirmed_completion_at=?", Time.now])
    redirect_to event_path(@event)
  end

end
