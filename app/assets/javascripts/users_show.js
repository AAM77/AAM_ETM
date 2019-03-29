
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

class UserEvent {
  constructor(object) {
    this.id = object.id
    this.name = object.name
  }
}

UserEvent.prototype.listItemLink = function() {
  return (
    `
    <li class="list-group-item">
      <a href="/events/${this.id}" target="_blank">${this.name}</a>
    </li>
    `
  )
}

function pageTitle() {
  $.get(`${window.location.href}.json`, function(data) {
    const user = new User(data)
    $('#user-homepage-header').append(`${user.username}'s Homepage`)
    $('#users-total-points').append(`${user.username}'s Points: ${user.total_points}`)
    $('#adminned-events-title').append(`Events ${user.username} Created`)
    $('#adminned-events-list').empty()

    user.adminned_events.forEach( event => {
      let newEvent = new UserEvent(event)
      let eventHTML = newEvent.listItemLink()
      $('#adminned-events-list').append(eventHTML)
    })
  })
}



// DOCUMENT.READY Function
$(function() {
  pageTitle();
})
