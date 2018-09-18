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
      change_admin_status
      redirect_to event_path(@event)
    else
      redirect_to events_path
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
  end

  def edit
    @event = Event.find_by(name: params[:name])
  end

  def update
  end

  def destroy
  end

  private

    def change_admin_status
      current_user.admin = true
      @user.save
    end

end
