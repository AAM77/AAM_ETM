class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
    @task_types = TaskType.all
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to task_path(@task)
    else
      redirect_to new_task_path
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
  end

  def destroy
    Task.find(params[:id]).destroy
    redirect_to tasks_path
  end


end
