class EventsController < ApplicationController
  before_action :event_exists?, except: [:index, :new, :create]
  before_action :set_event, except: [:index, :new, :create]

  ###########################################
  # handles routing to a list of all events #
  ###########################################
  def index
    @events = Event.all.order(:name)
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
    @ordered_tasks = @event.order_tasks
    @task = Task.new
    @admin = User.find(@event.admin_id)
  end

  ############################################
  # handles routing to form to edit an event #
  ############################################
  def edit
  end

  #############################
  # handles updating an event #
  #############################
  def update
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
    @ordered_tasks = @event.order_tasks
    @task = Task.new
  end

  private
    ########################
    # finds an event by id #
    ########################
    def set_event
      @event = Event.find_by(id: params[:id])
    end

    def event_exists?
      unless set_event
        redirect_to events_path
        flash[:warning] = "That event does not exist"
      end
    end

    def event_params
      params.require(:event).permit(:name, :deadline_date, :deadline_time, :admin_id)
    end

end
