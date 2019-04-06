class EventTask {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.admin_id = object.admin_id
    this.event_id = object.event_id
    this.points_awarded = object.points_awarded
    this.event_name = object.event.name
    this.admin_user = object.admin_user
    this.is_group_task = object.group_task
    this.deadline_date = object.deadline_date
    this.participants = object.users
  }
}

Task.prototype.addTask = function() {

  return (
    `
    <tr>
      <th scope="row"><%= event_instance.tasks.index(task_instance) + 1 %></th>
      <td><a href="/events/${this.event_id}/tasks/${this.id}">${this.name}</a></td>
      <td>${this.is_group_task ? 'Group Task' : 'Solo Task'}</td>
      <td>${this.points_awarded}</td>
      <td>${this.max_participants}</td>
      <td>${this.deadline_date}</td>
      <td>${this.participants}</td>
      <td><%= permission_to_join?(task_instance) { (check_task_availability task_instance) } %></td>
      <td><%= permission_to_join?(task_instance) { (display_user_checkbox task_instance) } %></td>
      <td><%= display_admin_checkbox task %></td>
      <td><%= link_to "Delete Task", task_path(task), method: :delete, data: { confirm: "Are you sure you want to delete this task?" } %></td>
      <td><%= display_admin_checkbox task %></td>
      <td><%= link_to "Delete Task", task_path(task), method: :delete, data: { confirm: "Are you sure you want to delete this task?" } %></td>
    </tr>
    `
  )
}

function createTask() {
  $.get(`${window.location.href}.json`, function(data) {
    $('form').submit(function(event) {
      event.preventDefault();

      let values = $(this).serialize();

      let response = $.post(`/events/${data['id']}/tasks`, values);

      response.done(function(data){
        const newTask = new EventTask(data);
        const taskHTML = newTask.addTask
        $('#incomplete_tasks_list').append(taskHTML)
        debugger;
      });
    });
  })
}


// DOCUMENT.READY Function
$(function() {
  createTask()
});
