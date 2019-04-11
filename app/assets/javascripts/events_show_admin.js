class EventTask {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.admin_id = object.admin_id
    this.event_id = object.event_id
    this.event_name = object.event.name
    this.admin_user = object.admin_user
    this.points_awarded = object.points_awarded
    this.max_participants = object.max_participants
    this.is_group_task = object.group_task
    this.deadline_date = object.deadline_date
    this.participants = object.users
    this.permission_to_join = object.permission_to_join
  }
}

EventTask.prototype.addTask = function() {
  return (
    `
    <tr>
      <td><a href="/events/${this.event_id}/tasks/${this.id}">${this.name}</a></td>
      <td>${this.is_group_task ? 'Group Task' : 'Solo Task'}</td>
      <td>${this.points_awarded}</td>
      <td>${this.max_participants}</td>
      <td>${this.deadline_date}</td>
      <td>${this.participants}</td>
      <td>${this.permission_to_join}</td>
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
  createTask()
});
