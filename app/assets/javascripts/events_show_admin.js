class EventTask {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.adminId = object.admin_id
    this.eventId = object.event_id
    this.eventName = object.event.name
    this.adminUser = object.admin_user
    this.pointsAwarded = object.points_awarded
    this.maxParticipants = object.max_participants
    this.isGroupTask = object.group_task
    this.deadlineDate = object.deadline_date
    this.participants = object.users
    this.permissionToJoin = object.permission_to_join
  }
}

EventTask.prototype.addTask = function() {
  return (
    `
    <tr>
      <td><a href="/events/${this.eventId}/tasks/${this.id}">${this.name}</a></td>
      <td>${this.isGroupTask ? 'Group Task' : 'Solo Task'}</td>
      <td>${this.pointsAwarded}</td>
      <td>${this.maxParticipants}</td>
      <td>${this.deadlineDate}</td>
      <td>${this.participants}</td>
      <td>${this.permissionToJoin}</td>
      <td><input type="checkbox" name="user_task_ids[]" id="user_task_ids_" value="${this.id}"></td>
      <td><input type="checkbox" name="admin_task_ids[]" id="admin_task_ids_" value="${this.id}"></td>
      <td><a data-confirm="Are you sure you want to delete this task?" rel="nofollow" data-method="delete" href="/tasks/${this.id}">Delete Task</a></td>
    </tr>
    `
  )
}

function createTask() {
  $.get(`${window.location.href}.json`, function(data) {
    $('#create_event_task form').submit(function(event) {
      event.preventDefault();

      let values = $(this).serialize();

      let response = $.post(`/events/${data['id']}/tasks`, values);

      response.done(function(data){
        const newTask = new EventTask(data);
        const taskHTML = newTask.addTask()
        $('#incomplete_tasks_list').append(taskHTML)
      });
    });
  })
}


// DOCUMENT.READY Function
$(document).on('turbolinks:load',function() {
  if ($('.events.show_admin').length > 0) {
    createTask()
  }
});
