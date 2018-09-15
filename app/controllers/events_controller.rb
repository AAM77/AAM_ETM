class EventsController < ApplicationController

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event][:name])

    if @event.save
      redirect_to event_path(@event)
    else
      redirect_to events_path
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
