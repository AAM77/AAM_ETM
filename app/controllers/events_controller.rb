class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to event_path(@event)
    else
      redirect_to events_path
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    @task = Task.new
  end

  def edit
    @event = Event.find_by(id: params[:id])
  end

  def update
  end

  def destroy
  end

  private

    def event_params
      params.require(:event).permit(:name, :deadline_date, :deadline_time, :admin_id)
    end

end
