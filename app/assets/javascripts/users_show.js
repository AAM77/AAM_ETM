
class User {
  constructor(object) {
    this.id = object.id
    this.username = object.username
    this.total_points = object.total_points
    this.adminned_events = object.events
    this.solo_tasks = object.solo_tasks
    this.group_tasks = object.group_tasks
    this.friends = object.all_friends
  }
}

function pageTitle() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#user-homepage-header').append(`${user.username}'s Homepage`)
    $('#users-total-points').append(`${user.username}'s Points: ${user.total_points}`)
  })
}



// DOCUMENT.READY Function
$(function() {
  pageTitle();
})
