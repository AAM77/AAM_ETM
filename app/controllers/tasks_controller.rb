class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def create
    @task = Task.new(task_params)
    @task.event_id = params[:event_id]

    if @task.save
      redirect_to event_path(@task.event_id)
    else
      redirect_to new_event_task_path
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    redirect_to event_path(@task.event_id)
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to tasks_path
  end

  private

    def task_params
      params.require(:task).permit(:name, :group_task, :points_awarded, :max_participants, :event_id, :user_completed_at, :admin_confirmed_completion_at)
    end

end
