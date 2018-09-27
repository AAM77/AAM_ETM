class UsersTasksController < ApplicationController

  def create
    
    @task = Task.find(params[:id])

    @task.add_participant(current_user)
    redirect_to event_path(@task.event_id)
  end


  def destroy
    task = Task.find(params[:id])

    task.remove_participant(current_user)

    redirect_to event_path(task.event_id)
  end

end
