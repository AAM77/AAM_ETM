
class Event {
  constructor(object) {
    this.id = object.id
    this.name = object.name
    this.adminUserId = object.admin_user.id
    this.adminUsername = object.admin_user.username
  }
}

Event.prototype.insertHTML = function() {
  return (
    `
    <li>
      <a href="/events/${this.id}">${this.name}</a>, by:
      <a href="/events/${this.adminUserId}">${this.adminUsername}</a>
    </li>
    `
  )
}

function displayAllEvents() {
  $.ajax({
    url: '/events.json',
    method: 'GET'
  })
  .done(function(events) {
    $('#all-events ol').empty()
    events.forEach(event => {
      let newEvent = new Event(event)
      let eventHTML = newEvent.insertHTML()
      $('#all-events ol').append(eventHTML)
    })
  })
}

function clickShowAllEvents() {
  $('a#dd-all-events').on('click', displayAllEvents());
}

$(function() {
  clickShowAllEvents()
});
