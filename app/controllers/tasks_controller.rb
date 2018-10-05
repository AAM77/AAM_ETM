class TasksController < ApplicationController
  before_action :set_task, except: [:index, :create]

  ###################################################
  # Lists all of the events nad corresponding tasks #
  ###################################################
  def index
    @tasks = Task.all
    @events = Event.all
  end


  ##################################
  # Handles the creation of a Task #
  ##################################
  def create
    @task = Task.new(task_params)
    @task.event_id = params[:event_id]

    if @task.save
      redirect_to event_path(@task.event_id)
    else
      redirect_to new_event_task_path
    end
  end

  ####################################
  # handles displaying the task show page #
  ####################################
  def show
    #@task = Task.find(params[:id])
  end

  #########################################
  # handles displaying the task edit page #
  #########################################
  def edit
    #@task = Task.find(params[:id])
  end

  #############################
  # handles updating the task #
  #############################
  def update
    #@task = Task.find(params[:id])
    @task.update(task_params)
    redirect_to event_path(@task.event_id)
  end

  ###########################
  # handles deleting a task #
  ###########################
  def destroy
    #@task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :group_task, :points_awarded, :max_participants, :event_id, :user_completed_at, :admin_confirmed_completion_at)
    end

end
