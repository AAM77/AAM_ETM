class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :event
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks

end
