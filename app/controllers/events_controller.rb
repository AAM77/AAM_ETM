class EventsController < ApplicationController
  before_action :set_event, except: [:index, :new, :create]

  ###########################################
  # handles routing to a list of all events #
  ###########################################
  def index
    @events = Event.all
  end

  ##############################################
  # handles routing to form to create an event #
  ##############################################
  def new
    @event = Event.new
  end

  ####################################
  # handles the creation of an event #
  ####################################
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to show_admin_event_path(@event)
    else
      redirect_to new_event_path
      flash[:warning] = @event.display_errors
    end
  end

  ###########################################
  # handles routing to an event's show page #
  ###########################################
  def show
    #@event = Event.find_by(id: params[:id])
    @task = Task.new
  end

  ############################################
  # handles routing to form to edit an event #
  ############################################
  def edit
    #@event = Event.find_by(id: params[:id])
  end

  #############################
  # handles updating an event #
  #############################
  def update
    #@event = Event.find_by(id: params[:id])
  end

  #############################
  # handles deleting an event #
  #############################
  def destroy
    event_name = @event.name
    Event.destroy(@event.id)
    redirect_to user_path(current_user)
    flash[:warning] = "You deleted the event: #{event_name}."
  end

  ############################################
  # handles routing to the admin's show page #
  ############################################
  def show_admin
    #@event = Event.find_by(id: params[:id])
    @task = Task.new
  end

  private
    ########################
    # finds an event by id #
    ########################
    def set_event
      @event = Event.find_by(id: params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :deadline_date, :deadline_time, :admin_id)
    end

end
