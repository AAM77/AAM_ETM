class TasksController < ApplicationController
  before_action :task_exists?, except: [:index, :create]
  before_action :set_task, except: [:index, :create]

  ###################################################
  # Lists all of the events nad corresponding tasks #
  ###################################################
  def index
    @tasks = Task.all.order(:name)
    @events = Event.all.order(:name)
  end


  ##################################
  # Handles the creation of a Task #
  ##################################
  def create
    @task = Task.new(task_params)
    @task.event_id = params[:event_id]

    if @task.save
      redirect_to show_admin_event_path(@task.event_id)
    else
      redirect_to new_event_task_path
    end
  end

  #########################################
  # handles displaying the task show page #
  #########################################
  def show
    @event = Event.find(@task.event_id)
  end

  #########################################
  # handles displaying the task edit page #
  #########################################
  def edit
  end

  #############################
  # handles updating the task #
  #############################
  def update
    @task.update(task_params)
    redirect_to event_path(@task.event_id)
  end

  ###########################
  # handles deleting a task #
  ###########################
  def destroy
    tasks_event_id = @task.event_id
    task_name = @task.name
    Task.destroy(@task.id)
    redirect_to "#{event_path(tasks_event_id)}/show_admin"
    flash[:warning] = "You have deleted the task: #{task_name}."
  end

  private

    def set_task
      @task = Task.find_by(id: params[:id])
    end

    def task_exists?
      unless set_task
        redirect_to tasks_path
        flash[:warning] = "That task does not exist"
      end
    end

    def task_params
      params.require(:task).permit(:name, :group_task, :points_awarded, :max_participants, :event_id, :user_completed_at, :admin_confirmed_completion_at)
    end

end
