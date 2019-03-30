class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :in_event

  belongs_to :event
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks

  def in_event
    event = Event.find(object.event_id)

    { id: event.id, name: event.name }
  end



end
